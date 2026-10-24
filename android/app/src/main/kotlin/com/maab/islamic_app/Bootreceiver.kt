package com.maab.islamic_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Alarms are wiped on reboot / app update / timezone change — re-arm everything. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val ids = AdhanStorage.loadKnownPrayerIds(context)
        AlarmScheduler.scheduleAll(context, ids)
    }
}