import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// println("FILE EXISTS: ${keystorePropertiesFile.exists()}")
// println("PROPERTIES: $keystoreProperties")

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}

val flutterVersionCode =
    localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1

val flutterVersionName =
    localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.example.soccer_sport_new"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs = freeCompilerArgs + listOf(
            "-Xskip-prerelease-check",
            "-Xallow-unstable-dependencies"
        )
    }

    defaultConfig {
        applicationId = "com.SoccerSport.SSC"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 55
        versionName = "1.1.14"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
    
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("com.google.auto.value:auto-value-annotations:1.10.4")
}

flutter {
    source = "../.."
}
