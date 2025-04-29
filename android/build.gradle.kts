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
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

tasks.register("checkSdkLicenses") {
    doLast {
        val sdkManager = File(System.getenv("ANDROID_HOME") ?: "/usr/lib/android-sdk", "tools/bin/sdkmanager")
        if (!sdkManager.exists()) {
            throw GradleException("SDK Manager not found. Please ensure ANDROID_HOME is set correctly.")
        }
        exec {
            commandLine(sdkManager.absolutePath, "--licenses")
        }
    }
}

tasks.named("preBuild") {
    dependsOn("checkSdkLicenses")
}
