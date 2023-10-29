import java.util.*

data class CallLogModel(
    val phoneNumber: String,
    val personName: String,
    val callType: String,
    val callDate: Date,
    val callDuration: String
)
