allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some Flutter plugins still declare an old compileSdk of their own
// (observed: geocoding_android on android-33). Their transitive AndroidX
// dependencies then fail the release build's AAR-metadata check with
// "requires libraries and applications that depend on it to compile
// against version 34 or later", which is an error, not a warning — the
// bundleRelease task dies on it.
//
// Rather than pinning each offending plugin by hand as it appears, raise
// every Android *library* module in the build (i.e. the plugins; :app is an
// application module and is untouched) to the same compileSdk :app itself
// uses. Keep this in sync with `compileSdk` in app/build.gradle.kts, which
// documents why that number is what it is.
val pluginCompileSdk = 37

subprojects {
    afterEvaluate {
        extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)?.let { ext ->
            if ((ext.compileSdk ?: 0) < pluginCompileSdk) {
                ext.compileSdk = pluginCompileSdk
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
