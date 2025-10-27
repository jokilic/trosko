package com.josipkilic.trosko

import com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        FlutterForegroundTaskPlugin.setPluginRegistrantCallback { registry ->
            GeneratedPluginRegistrant.registerWith(registry)
        }
        super.configureFlutterEngine(flutterEngine)
    }
}
