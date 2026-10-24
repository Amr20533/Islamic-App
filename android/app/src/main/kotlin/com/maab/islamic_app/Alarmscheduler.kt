package com.maab.islamic_app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import java.util.Calendar
import java.util.Date

/**
 * One independent alarm per prayer, keyed by whatever string [id] the Dart
 * side uses (e.g. your PrayerAlarmConfig.key — "fajr", "dhuhr", etc). Each
 * has its own enabled/time/label, so toggling one prayer never touches
 * another.
 */
object AlarmScheduler {
    private const val PREFS = "adhan_alarm_prefs"

    private fun prefs(ctx: Context) = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    private fun key(id: String, name: String) = "${id}_$name"

    fun save(ctx: Context, id: String, enabled: Boolean, hour: Int, minute: Int, label: String) {
        Log.d("AdhanDebug", "AlarmScheduler.save[$id] enabled=$enabled hour=$hour minute=$minute")
        prefs(ctx).edit()
            .putBoolean(key(id, "enabled"), enabled)
            .putInt(key(id, "hour"), hour).putInt(key(id, "minute"), minute)
            .putString(key(id, "label"), label)
            .apply()
    }

    fun label(ctx: Context, id: String): String = prefs(ctx).getString(key(id, "label"), id) ?: id

    private fun nextOccurrence(hour: Int, minute: Int, after: Long): Long {
        val cal = Calendar.getInstance().apply {
            timeInMillis = after
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        if (cal.timeInMillis <= after) cal.add(Calendar.DAY_OF_YEAR, 1)
        return cal.timeInMillis
    }

    fun nextStartMillis(ctx: Context, id: String): Long? {
        val p = prefs(ctx)
        if (!p.getBoolean(key(id, "enabled"), false)) return null
        return nextOccurrence(p.getInt(key(id, "hour"), 0), p.getInt(key(id, "minute"), 0), System.currentTimeMillis())
    }

    // Stable per-id request codes. Collisions are extremely unlikely across
    // the handful of prayer keys this app uses, but if you ever see two
    // prayers fighting over one alarm slot, switch this to an explicit map.
    private fun requestCode(id: String) = 5000 + (id.hashCode() and 0xFFF)

    private fun alarmIntent(ctx: Context, id: String): PendingIntent {
        val intent = Intent(ctx, AdhanAlarmReceiver::class.java).putExtra("prayerId", id)
        return PendingIntent.getBroadcast(
            ctx, requestCode(id), intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    /** Returns true if armed. False means the exact-alarm permission is missing. */
    fun scheduleNext(ctx: Context, id: String): Boolean {
        val trigger = nextStartMillis(ctx, id) ?: run {
            Log.d("AdhanDebug", "scheduleNext[$id]: disabled, cancelling")
            cancel(ctx, id)
            return false
        }
        Log.d("AdhanDebug", "scheduleNext[$id]: arming for ${Date(trigger)}")
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val show = PendingIntent.getActivity(
            ctx, requestCode(id), Intent(ctx, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return try {
            am.setAlarmClock(AlarmManager.AlarmClockInfo(trigger, show), alarmIntent(ctx, id))
            Log.d("AdhanDebug", "scheduleNext[$id]: armed successfully")
            true
        } catch (e: SecurityException) {
            Log.e("AdhanDebug", "scheduleNext[$id]: SecurityException - exact alarm permission missing", e)
            false
        }
    }

    fun scheduleAll(ctx: Context, ids: List<String>) {
        ids.forEach { scheduleNext(ctx, it) }
    }

    fun cancel(ctx: Context, id: String) {
        Log.d("AdhanDebug", "AlarmScheduler.cancel[$id]")
        val am = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        am.cancel(alarmIntent(ctx, id))
    }
}