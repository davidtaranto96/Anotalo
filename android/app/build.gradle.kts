plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services — habilita Firebase a leer google-services.json en build.
    id("com.google.gms.google-services")
    // Crashlytics — sube symbols al build time para que stacks queden
    // legibles en la consola. Sin esto los crashes vienen ofuscados.
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.davidtaranto.arquitectura_enfoque"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.davidtaranto.arquitectura_enfoque"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Signing con debug keys por ahora, hasta tener un keystore
            // real para Play Store.
            signingConfig = signingConfigs.getByName("debug")
            // R8 con minify ON + nuestras proguard rules para mantener
            // las clases Gson de flutter_local_notifications (sino
            // crashea el ScheduledNotificationBootReceiver).
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
