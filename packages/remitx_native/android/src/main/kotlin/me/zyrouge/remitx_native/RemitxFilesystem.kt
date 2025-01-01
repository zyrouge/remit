package me.zyrouge.remitx_native

import android.app.Activity
import android.database.Cursor
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

object RemitxFilesystem {
    private val selectionColumns = arrayOf(
        DocumentsContract.Document.COLUMN_DOCUMENT_ID,
        DocumentsContract.Document.COLUMN_DISPLAY_NAME,
        DocumentsContract.Document.COLUMN_MIME_TYPE,
        DocumentsContract.Document.COLUMN_LAST_MODIFIED,
        DocumentsContract.Document.COLUMN_SIZE,
    )

    private fun parseCursor(cursor: Cursor, uriFactory: (String) -> Uri): Map<String, Any> {
        val id = cursor.getString(0)
        val name = cursor.getString(1)
        val mimeType = cursor.getString(2)
        val lastModified = cursor.getLong(3)
        val size = cursor.getLong(4)
        val uri = uriFactory(id)
        return mapOf<String, Any>(
            "id" to id,
            "name" to name,
            "mimeType" to mimeType,
            "lastModified" to lastModified,
            "size" to size,
            "uri" to uri.toString(),
            "_isDirectory" to mimeType.contentEquals(DocumentsContract.Document.MIME_TYPE_DIR),
        )
    }

    private fun queryDocumentUri(activity: Activity, uri: Uri): Map<String, Any>? {
        return activity.contentResolver.query(uri, selectionColumns, null, null, null)?.use {
            when {
                it.moveToNext() -> parseCursor(it) { _ -> uri }
                else -> null
            }
        }
    }

    fun statDocumentUri(activity: Activity, call: MethodCall, result: Result) {
        val uri = Uri.parse(call.argument("uri"))
        val info = queryDocumentUri(activity, uri)
        result.success(info)
    }

    fun statDocumentTreeUri(activity: Activity, call: MethodCall, result: Result) {
        val treeUri = Uri.parse(call.argument("uri"))
        val uri = DocumentsContract.buildDocumentUriUsingTree(
            treeUri,
            DocumentsContract.getTreeDocumentId(treeUri)
        )
        val info = queryDocumentUri(activity, uri)
        result.success(info)
    }

    fun listDocumentTreeUri(activity: Activity, call: MethodCall, result: Result) {
        val uri = Uri.parse(call.argument("uri"))
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(
            uri,
            DocumentsContract.getDocumentId(uri)
        )
        val items = mutableListOf<Map<String, Any>>()
        activity.contentResolver.query(childrenUri, selectionColumns, null, null, null)?.use {
            while (it.moveToNext()) {
                val file = parseCursor(it) { id ->
                    DocumentsContract.buildDocumentUriUsingTree(uri, id)
                }
                items.add(file)
            }
        }
        result.success(items)
    }
}