##───────────────────────────────────────────────────────────────────────────────
## flutter_local_notifications
## Without these rules R8 strips/renames the BroadcastReceiver classes that fire
## scheduled notifications in the background, breaking ALL alarms in release mode.
##───────────────────────────────────────────────────────────────────────────────
-keep class com.dexterous.** { *; }
-keepnames class com.dexterous.** { *; }

##───────────────────────────────────────────────────────────────────────────────
## timezone / tzdata — used by flutter_local_notifications zonedSchedule()
##───────────────────────────────────────────────────────────────────────────────
-keep class org.threeten.** { *; }
-dontwarn org.threeten.**

##───────────────────────────────────────────────────────────────────────────────
## Flutter engine & plugin registry
##───────────────────────────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

##───────────────────────────────────────────────────────────────────────────────
## Kotlin coroutines (used internally by several plugins)
##───────────────────────────────────────────────────────────────────────────────
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembers class kotlinx.coroutines.** { volatile <fields>; }

##───────────────────────────────────────────────────────────────────────────────
## audioplayers
##───────────────────────────────────────────────────────────────────────────────
-keep class xyz.luan.audioplayers.** { *; }

##───────────────────────────────────────────────────────────────────────────────
## geolocator
##───────────────────────────────────────────────────────────────────────────────
-keep class com.baseflow.geolocator.** { *; }

##───────────────────────────────────────────────────────────────────────────────
## General Android safety
##───────────────────────────────────────────────────────────────────────────────
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
