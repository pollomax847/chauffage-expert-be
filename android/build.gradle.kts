allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
    plugins.withType<org.jetbrains.kotlin.gradle.plugin.KotlinBasePlugin> {
        kotlin {
            jvmToolchain(11) // Ensure JVM target compatibility with Java 11
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

tasks.register("checkSdkLicenses") {
    description = "Checks if Android SDK licenses have been accepted."
    group = "Android"

    // This task primarily checks environment setup and potentially modifies system state (license acceptance).
    // It doesn't produce cacheable outputs in the traditional sense.
    outputs.upToDateWhen { true } // Mark as always up-to-date to avoid unnecessary runs if licenses are accepted externally.

    doLast {
        val androidHomePath = System.getenv("ANDROID_HOME")
        if (androidHomePath.isNullOrBlank()) {
            logger.warn("ANDROID_HOME environment variable is not set. Skipping SDK license check.")
            // Optionally, throw an exception if ANDROID_HOME is mandatory for the build environment.
            // throw GradleException("ANDROID_HOME environment variable is not set.")
            return@doLast
        }

        val sdkRoot = File(androidHomePath)
        // Try common locations for sdkmanager within ANDROID_HOME
        val possibleSdkManagerPaths = listOf(
            "cmdline-tools/latest/bin/sdkmanager",
            "tools/bin/sdkmanager"
        )
        val sdkManager = possibleSdkManagerPaths
            .map { sdkRoot.resolve(it) }
            .firstOrNull { it.exists() && it.canExecute() }

        if (sdkManager == null) {
            logger.warn("SDK Manager (sdkmanager) not found in expected locations within ANDROID_HOME: $androidHomePath. Skipping license check.")
            // Optionally, throw an exception.
            // throw GradleException("SDK Manager not found in $androidHomePath. Searched paths: ${possibleSdkManagerPaths.joinToString()}")
            return@doLast
        }

        logger.info("Found SDK Manager at: ${sdkManager.absolutePath}")
        logger.info("Running SDK license check/acceptance. This might require user interaction if licenses are not accepted.")

        try {
            exec {
                commandLine(sdkManager.absolutePath, "--licenses")
                // Optional: Capture output or handle errors more gracefully
                // standardOutput = System.out
                // errorOutput = System.err
            }
            logger.info("SDK license check completed.")
        } catch (e: Exception) {
            logger.error("Failed to run sdkmanager --licenses. Please accept licenses manually.", e)
            // Re-throw to fail the build if license acceptance is critical here.
            // throw GradleException("Failed to run SDK license check. Please accept licenses manually.", e)
        }
    }
}

// Consider if this dependency is truly needed on every build.
// It might be better run manually or only in CI environments.
// tasks.named("preBuild") {
//     dependsOn("checkSdkLicenses")
// }
