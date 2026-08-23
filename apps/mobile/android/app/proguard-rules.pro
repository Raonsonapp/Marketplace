# TajikShop release R8/ProGuard rules.
# Android's own defaults (proguard-android-optimize.txt) handle the Flutter
# engine and standard framework classes; these additions cover libraries in
# this app that rely on reflection or aren't yet R8-aware upstream.

# Firebase (Auth/Core) — Firebase's model classes are deserialized via
# reflection and must keep their field names.
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Core (Flutter's deferred-components support pulls this in
# even when unused by this app).
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# mobile_scanner (ML Kit barcode scanning) ships its own consumer rules,
# but keep the public API surface defensively against R8 shrinking it from
# under the plugin's Dart<->platform channel calls.
-keep class com.google.mlkit.vision.barcode.** { *; }
-dontwarn com.google.mlkit.vision.barcode.**
