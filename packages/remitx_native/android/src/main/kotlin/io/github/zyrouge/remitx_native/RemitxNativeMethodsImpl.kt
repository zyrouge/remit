package io.github.zyrouge.remitx_native

import android.net.Uri
import androidx.app.Activity

fun GetRealPathFromURI(activity: Activity, uri: Uri): String? =
        activity.contentResolver.query(uri, null, null, null, null)?.use {
            val dataIndex = it.getColumnIndex(OpenableColumns.DATA)
            it.moveToFirst()
            it.getString(dataIndex)
        }
