package me.zyrouge.remitx_native

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodChannel.Result

class RemitxFilesystemPicker {
    private var openDocumentResult: Result? = null
    private var openDocumentTreeResult: Result? = null

    fun startOpenDocumentActivity(activity: Activity, result: Result) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
        activity.startActivityForResult(intent, OPEN_DOCUMENT_RESULT_CODE)
        openDocumentResult = result
    }

    fun startOpenDocumentTreeActivity(activity: Activity, result: Result) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        activity.startActivityForResult(intent, OPEN_DOCUMENT_TREE_RESULT_CODE)
        openDocumentTreeResult = result
    }

    fun handleOpenDocumentActivity(resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK && data != null) {
            val uri = data.data!!
            openDocumentResult?.success(uri.toString())
        }
        return false
    }

    fun handleOpenDocumentTreeActivity(resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK && data != null) {
            val uri = data.data!!
            openDocumentTreeResult?.success(uri.toString())
        }
        return false
    }

    companion object {
        const val OPEN_DOCUMENT_RESULT_CODE = 1010
        const val OPEN_DOCUMENT_TREE_RESULT_CODE = 1011
    }
}