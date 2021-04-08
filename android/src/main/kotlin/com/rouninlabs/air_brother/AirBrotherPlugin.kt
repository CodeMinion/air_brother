package com.rouninlabs.air_brother

import android.content.Context
import androidx.annotation.NonNull
import com.brother.sdk.BrotherAndroidLib
import com.rouninlabs.air_brother.method.GetNetworkDevicesMethodCall
import com.rouninlabs.air_brother.method.PerformPrintMethodCall
import com.rouninlabs.air_brother.method.PerformScanMethodCall

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AirBrotherPlugin */
class AirBrotherPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "air_brother")
        channel.setMethodCallHandler(this)
        mContext = flutterPluginBinding.applicationContext
        BrotherAndroidLib.initialize(mContext)

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        else if (call.method == GetNetworkDevicesMethodCall.METHOD_NAME) {
            GetNetworkDevicesMethodCall(context = mContext, call = call, result = result).execute()
        }
        else if (call.method == PerformScanMethodCall.METHOD_NAME) {
            PerformScanMethodCall(context = mContext, call = call, result = result).execute()
        }
        else if (call.method == PerformPrintMethodCall.METHOD_NAME) {
            PerformPrintMethodCall(context = mContext, call = call, result = result).execute()
        }
        else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
