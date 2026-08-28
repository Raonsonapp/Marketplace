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

// Some Flutter plugins still declare an old compileSdk of their own
// (observed: geocoding_android on android-33). Their transitive AndroidX
// dependencies then fail the release build's AAR-metadata check with
// "requires libraries and applications that depend on it to compile
// against version 34 or later", which is an error, not a warning — the
// bundleRelease task dies on it.
//
// Rather than pinning each offending plugin by hand as it appears, raise
// every Android *library* module in the build (i.e. the plugins; :app is an
// application module, has no LibraryExtension, and is left alone) to the
// same compileSdk :app itself uses. Keep this in sync with `compileSdk` in
// app/build.gradle.kts, which documents why that number is what it is.
//
// This must stay ABOVE the `evaluationDependsOn(":app")` block below: that
// block evaluates :app eagerly, and registering an afterEvaluate hook on an
// already-evaluated project is an error ("Cannot run
// Project.afterEvaluate(Action) when the project is already evaluated").
// Registering here, before anything is evaluated, also means our hook runs
// before AGP's own afterEvaluate finalizes the value.
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

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
