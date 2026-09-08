# AutoValue fix
-keep class com.google.auto.value.** { *; }
-dontwarn com.google.auto.value.**

# OpenTelemetry fix
-keep class io.opentelemetry.** { *; }
-dontwarn io.opentelemetry.**