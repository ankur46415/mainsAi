import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
println("Looking for key.properties at: ${keystorePropertiesFile.absolutePath}")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("key.properties not found. Release signing will be skipped.")
}

android {
    namespace = "com.mainsapp"
    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.mainsapp"

        minSdk = 21  
        targetSdk = flutter.targetSdkVersion
        versionCode = 10
        versionName = "1.0.9"
        multiDexEnabled = true
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                val props = keystoreProperties

                val storeFilePath = props["storeFile"]?.toString()
                    ?: throw GradleException("Missing storeFile in key.properties")
                storeFile = file(storeFilePath)

                storePassword = props["storePassword"]?.toString()
                    ?: throw GradleException("Missing storePassword in key.properties")
                keyAlias = props["keyAlias"]?.toString()
                    ?: throw GradleException("Missing keyAlias in key.properties")
                keyPassword = props["keyPassword"]?.toString()
                    ?: throw GradleException("Missing keyPassword in key.properties")
            }
        }
    }



    buildTypes {
        release {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                println("Warning: Building release without signing because key.properties is missing.")
            }
            isMinifyEnabled = false  // Disable minification for release
            isShrinkResources = false  // Disable resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // Add packaging options to handle audio files
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            pickFirsts += "lib/**/libc++_shared.so"
        }
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.media:media:1.6.0")
}

flutter {
    source = "../.."
}
