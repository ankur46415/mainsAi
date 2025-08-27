package com.mainsapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Explicitly register the WebViewFlutterPlugin to ensure WebView functionality
        flutterEngine.plugins.add(WebViewFlutterPlugin())
    }
}