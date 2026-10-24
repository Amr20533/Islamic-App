package com.maab.islamic_app

import android.content.Context

/** Remembers which prayer ids exist at all, so BootReceiver can re-arm them
 * without Dart being involved. Updated every time Dart calls "sync". */
object AdhanStorage {
    private const val PREFS = "adhan_alarm_prefs"
    private const val KEY = "known_prayer_ids"

    fun rememberId(ctx: Context, id: String) {
        val prefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val known = (prefs.getStringSet(KEY, emptySet()) ?: emptySet()).toMutableSet()
        known.add(id)
        prefs.edit().putStringSet(KEY, known).apply()
    }

    fun loadKnownPrayerIds(ctx: Context): List<String> {
        val prefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return (prefs.getStringSet(KEY, emptySet()) ?: emptySet()).toList()
    }
}