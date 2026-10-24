package com.maab.islamic_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/** Fires at the actual prayer time. [prayerId] tells us which one. */
class AdhanAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val prayerId = intent.getStringExtra("prayerId") ?: return
        Log.d("AdhanDebug", "AdhanAlarmReceiver fired for $prayerId")
        AlarmScheduler.scheduleNext(context, prayerId) // re-arm tomorrow
        PlaybackService.start(context, prayerId)
    }
}