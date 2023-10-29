package com.vipin.login_mvvm

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"

    private val androidMethodChannel = "androidMethodChannel"

    companion object {
        var mainResult: MethodChannel.Result? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

//        To start call logs activity
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            androidMethodChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "readPhoneCall" -> {
                    var userName = call.argument<String>("userName").toString()
                    mainResult = result
                    val intent = Intent(this, CallLogActivity::class.java)
                    intent.putExtra("userName", userName)
                    startActivity(intent)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
