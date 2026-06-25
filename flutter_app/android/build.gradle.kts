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
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(android) == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    
                    var pkg = project.group.toString()
                    val manifest = project.file("src/main/AndroidManifest.xml")
                    if (manifest.exists()) {
                        val text = manifest.readText()
                        val match = Regex("""package="([^"]+)"""").find(text)
                        if (match != null) {
                            pkg = match.groupValues[1]
                        }
                    }
                    
                    if (pkg.isNotEmpty() && pkg != "unspecified") {
                        setNamespace.invoke(android, pkg)
                    }
                }
            } catch (e: Exception) {
            }
        }
    }
}

// Force a modern compileSdk on every plugin module. Some older plugins
// (e.g. isar_flutter_libs) pin a low compileSdk of their own, which breaks the
// release build's resource linking with "android:attr/lStar not found"
// (lStar is an API 31 attribute). The app module is left untouched.
subprojects {
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null && project.name != "app") {
            try {
                val setCompileSdk =
                    android.javaClass.getMethod("setCompileSdk", Integer::class.java)
                setCompileSdk.invoke(android, 36)
            } catch (e: Exception) {
                try {
                    val legacy = android.javaClass.getMethod(
                        "compileSdkVersion", Int::class.javaPrimitiveType
                    )
                    legacy.invoke(android, 36)
                } catch (e2: Exception) {
                }
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
