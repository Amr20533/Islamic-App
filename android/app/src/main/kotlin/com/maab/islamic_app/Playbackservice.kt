package com.maab.islamic_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.util.Log

/**
 * Plays res/raw/adhan.* directly (the same file your notification sound
 * already references) through a proper foreground service — reliable in
 * the background, locked or not, and requests audio focus so it interrupts
 * any music currently playing and lets it resume afterward.
 */
class PlaybackService : Service() {

    private var player: MediaPlayer? = null
    private var prayerId: String = ""
    private val audioManager by lazy { getSystemService(AUDIO_SERVICE) as AudioManager }
    private var focusRequest: AudioFocusRequest? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            Log.d("AdhanDebug", "PlaybackService: stop requested")
            stopSelf()
            return START_NOT_STICKY
        }

        prayerId = intent?.getStringExtra(EXTRA_PRAYER_ID) ?: ""
        Log.d("AdhanDebug", "PlaybackService.onStartCommand for $prayerId")

        try {
            startInForeground()
        } catch (e: Exception) {
            Log.e("AdhanDebug", "PlaybackService: notification failed, continuing without it", e)
        }
        requestAudioFocus()
        playAdhan()
        return START_NOT_STICKY
    }

    private fun playAdhan() {
        try {
            val resId = resources.getIdentifier("adhan", "raw", packageName)
            if (resId == 0) {
                Log.e("AdhanDebug", "PlaybackService: res/raw/adhan.* not found")
                stopSelf()
                return
            }
            val afd = resources.openRawResourceFd(resId)
            val mp = MediaPlayer()
            player = mp
            mp.setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            )
            mp.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            afd.close()
            mp.setOnPreparedListener {
                Log.d("AdhanDebug", "PlaybackService: prepared, starting Adhan")
                it.start()
            }
            mp.setOnCompletionListener {
                Log.d("AdhanDebug", "PlaybackService: Adhan finished")
                stopSelf()
            }
            mp.setOnErrorListener { _, what, extra ->
                Log.e("AdhanDebug", "PlaybackService: MediaPlayer error what=$what extra=$extra")
                stopSelf()
                true
            }
            mp.prepareAsync()
        } catch (e: Exception) {
            Log.e("AdhanDebug", "PlaybackService: exception playing Adhan", e)
            stopSelf()
        }
    }

    private fun requestAudioFocus() {
        try {
            val attrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build()
            val request = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(attrs)
                .setWillPauseWhenDucked(false)
                .build()
            focusRequest = request
            val result = audioManager.requestAudioFocus(request)
            Log.d("AdhanDebug", "requestAudioFocus result=$result")
        } catch (e: Exception) {
            Log.e("AdhanDebug", "requestAudioFocus failed, continuing anyway", e)
        }
    }

    private fun abandonAudioFocus() {
        try {
            focusRequest?.let { audioManager.abandonAudioFocusRequest(it) }
            focusRequest = null
        } catch (e: Exception) {
            Log.e("AdhanDebug", "abandonAudioFocus failed", e)
        }
    }

    private fun startInForeground() {
        if (Build.VERSION.SDK_INT >= 26) {
            getSystemService(NotificationManager::class.java).createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "Adhan playback", NotificationManager.IMPORTANCE_LOW)
            )
        }
        val label = AlarmScheduler.label(this, prayerId)
        val openApp = PendingIntent.getActivity(
            this, 0, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE
        )
        val stop = PendingIntent.getService(
            this, 1,
            Intent(this, PlaybackService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_IMMUTABLE
        )
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, CHANNEL_ID)
            else Notification.Builder(this)
        val notification = builder
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentTitle("آذان $label")
            .setContentText("اضغط إيقاف لإنهاء الأذان")
            .setContentIntent(openApp)
            .addAction(android.R.drawable.ic_media_pause, "إيقاف", stop)
            .setOngoing(true)
            .build()

        if (Build.VERSION.SDK_INT >= 29) {
            startForeground(NOTIF_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(NOTIF_ID, notification)
        }
    }

    override fun onDestroy() {
        player?.let { try { it.release() } catch (_: Exception) {} }
        player = null
        abandonAudioFocus()
        super.onDestroy()
    }

    companion object {
        const val ACTION_STOP = "com.maab.islamic_app.action.STOP_ADHAN"
        private const val EXTRA_PRAYER_ID = "prayer_id"
        private const val CHANNEL_ID = "adhan_playback"
        private const val NOTIF_ID = 501

        fun start(ctx: Context, prayerId: String) {
            val intent = Intent(ctx, PlaybackService::class.java).putExtra(EXTRA_PRAYER_ID, prayerId)
            try {
                if (Build.VERSION.SDK_INT >= 26) ctx.startForegroundService(intent)
                else ctx.startService(intent)
            } catch (e: Exception) {
                Log.e("AdhanDebug", "PlaybackService.start failed", e)
            }
        }

        fun stop(ctx: Context) {
            ctx.startService(Intent(ctx, PlaybackService::class.java).setAction(ACTION_STOP))
        }
    }
}