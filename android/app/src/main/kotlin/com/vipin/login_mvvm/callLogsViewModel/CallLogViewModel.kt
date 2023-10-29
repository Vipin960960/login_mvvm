package com.example.mvvmarchitecture.callLogsViewModel

import CallLogModel
import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import android.provider.CallLog
import androidx.lifecycle.*
import java.util.*

class CallLogViewModel(application: Application) : ViewModel() {
    private val _callLogs = MutableLiveData<List<CallLogModel>>()
    val callLogs: LiveData<List<CallLogModel>> get() = _callLogs

    companion object {
        class ViewModelFactory(
            private val application: Application
        ) : ViewModelProvider.Factory {
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return CallLogViewModel(application) as T
            }
        }
    }

    @SuppressLint("Range")
    fun loadCallLogs(context: Context) {
        val callLogsList = mutableListOf<CallLogModel>()
        val cursor = context.contentResolver.query(
            CallLog.Calls.CONTENT_URI,
            null,
            null,
            null,
            CallLog.Calls.DATE + " DESC"
        )

        cursor?.use { c ->
            var numberIndex = c.getColumnIndex(CallLog.Calls.NUMBER)
            var nameIndex = c.getColumnIndex(CallLog.Calls.CACHED_NAME)
            val typeIndex = c.getColumnIndex(CallLog.Calls.TYPE)
            val dateIndex = c.getColumnIndex(CallLog.Calls.DATE)
            val durationIndex = c.getColumnIndex(CallLog.Calls.DURATION)

            while (c.moveToNext()) {
                var phNumber = c.getString(numberIndex)
                var name = c.getString(nameIndex)
                val callType = c.getString(typeIndex)
                val callDate = Date(c.getLong(dateIndex))
                val callDuration = c.getString(durationIndex)

                val dir = when (callType.toInt()) {
                    CallLog.Calls.OUTGOING_TYPE -> "OUTGOING"
                    CallLog.Calls.INCOMING_TYPE -> "INCOMING"
                    CallLog.Calls.MISSED_TYPE -> "MISSED"
                    else -> "UNKNOWN"
                }

//                Log.d("CallLogViewModel", "tocheck: loadCallLogs: "+phNumber+"dir: "+dir+"callDate:"+callDate+"callDuration: "+callDuration)
                val callLog = CallLogModel(phNumber,name, dir, callDate, callDuration)
                callLogsList.add(callLog)
            }
        }
        _callLogs.value = callLogsList
    }
}
