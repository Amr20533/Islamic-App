package com.maab.islamic_app

import android.Manifest
import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "com.maab.islamic_app/battery"
    private val ADHAN_CHANNEL = "com.maab.islamic_app/adhan"

    private fun canScheduleExactAlarms(): Boolean {
        if (Build.VERSION.SDK_INT < 31) return true
        val am = getSystemService(AlarmManager::class.java)
        return am.canScheduleExactAlarms()
    }

    private fun requestExactAlarmPermission() {
        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
            data = Uri.parse("package:$packageName")
        }
        startActivity(intent)
    }

    override fun onResume() {
        super.onResume()
        if (canScheduleExactAlarms()) {
            AlarmScheduler.scheduleAll(this, AdhanStorage.loadKnownPrayerIds(this))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BATTERY_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isIgnoringBatteryOptimizations" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                        val isIgnoring = powerManager?.isIgnoringBatteryOptimizations(packageName) ?: false
                        result.success(isIgnoring)
                    } else {
                        result.success(true)
                    }
                }
                "requestIgnoreBatteryOptimizations" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        try {
                            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                                data = Uri.parse("package:$packageName")
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                                startActivity(intent)
                                result.success(true)
                            } catch (e2: Exception) {
                                try {
                                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                                        data = Uri.parse("package:$packageName")
                                    }
                                    startActivity(intent)
                                    result.success(true)
                                } catch (e3: Exception) {
                                    result.success(false)
                                }
                            }
                        }
                    } else {
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ADHAN_CHANNEL
        ).setMethodCallHandler { call, result ->
            val ctx = applicationContext
            when (call.method) {
                "sync" -> {
                    val id = call.argument<String>("id") ?: run {
                        result.error("MISSING_ID", "id is required", null); return@setMethodCallHandler
                    }
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    val hour = call.argument<Int>("hour") ?: 0
                    val minute = call.argument<Int>("minute") ?: 0
                    val label = call.argument<String>("label") ?: id

                    AdhanStorage.rememberId(ctx, id)
                    AlarmScheduler.save(ctx, id, enabled, hour, minute, label)

                    if (enabled && !canScheduleExactAlarms()) {
                        requestExactAlarmPermission()
                        result.success(null)
                        return@setMethodCallHandler
                    }

                    if (enabled) AlarmScheduler.scheduleNext(ctx, id) else AlarmScheduler.cancel(ctx, id)
                    result.success(AlarmScheduler.nextStartMillis(ctx, id))
                }
                "playNow" -> {
                    val id = call.argument<String>("id") ?: "test"
                    PlaybackService.start(ctx, id)
                    result.success(null)
                }
                "stop" -> {
                    PlaybackService.stop(ctx)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}