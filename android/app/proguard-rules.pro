# ─── Flutter ─────────────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# ─── flutter_local_notifications ────────────────────────────────────────────
# Razón: el plugin usa Gson para serializar notificaciones programadas en
# SharedPreferences. R8 strip-ea los Type generics necesarios para
# deserializar al rebootear, lo que dispara
# "Missing type parameter" en ScheduledNotificationBootReceiver.
# Estas reglas mantienen los modelos + atributos de generics intactos.
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.** { *; }
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# ─── Drift (sqlite3_flutter_libs) ────────────────────────────────────────────
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }
