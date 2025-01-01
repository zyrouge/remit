package me.zyrouge.remitx_native

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** RemitxNativePlugin */
class RemitxNativePlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private val filesystemPicker = RemitxFilesystemPicker()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "remitx_native")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "openFilePicker" -> filesystemPicker.startOpenDocumentActivity(activity!!, result)
            "openFolderPicker" -> filesystemPicker.startOpenDocumentTreeActivity(activity!!, result)
            "statFileUri" -> RemitxFilesystem.statDocumentUri(activity!!, call, result)
            "statFolderUri" -> RemitxFilesystem.statDocumentTreeUri(activity!!, call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (resultCode) {
            RemitxFilesystemPicker.OPEN_DOCUMENT_RESULT_CODE ->
                filesystemPicker.handleOpenDocumentActivity(resultCode, data)

            RemitxFilesystemPicker.OPEN_DOCUMENT_TREE_RESULT_CODE ->
                filesystemPicker.handleOpenDocumentTreeActivity(resultCode, data)

            else -> false
        }
    }
}
