package com.example.mvvmarchitecture.Adapters

import CallLogModel
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.vipin.login_mvvm.databinding.CallLogItemBinding
import com.vipin.login_mvvm.utils.OnItemClickListener
import java.text.SimpleDateFormat
import java.util.*

class MainAdapter(
    private val list: ArrayList<CallLogModel>,
    private val listener: OnItemClickListener
) : RecyclerView.Adapter<MainAdapter.ViewHolder>() {
    lateinit var binding: CallLogItemBinding

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflater = LayoutInflater.from(parent.context)
        binding = CallLogItemBinding.inflate(inflater, parent, false)
        return ViewHolder(binding, listener)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(list[position])
    }

    class ViewHolder(val binding: CallLogItemBinding, private val listener: OnItemClickListener) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(item: CallLogModel) {
            if (item.personName.trim().isEmpty()) {
                binding.textPhoneNumber.text = item.phoneNumber
            } else {
                binding.textPhoneNumber.text = item.personName
            }
            binding.textCallType.text = item.callType
            val callDate: Date = item.callDate
            val formatter = SimpleDateFormat("h:mm a")
            val formattedDate = formatter.format(callDate)
            binding.textCallDate.text = formattedDate
            binding.textCallDuration.text = convertCallDuration(item.callDuration)

            binding.constraintLayout.setOnClickListener {
                listener.onItemClick(item)
            }
        }
    }

    override fun getItemCount(): Int {
        return list.size
    }

}

fun convertCallDuration(callDurationString: String): String {
    val callDuration = callDurationString.toInt()

    if (callDuration < 60) {
        return "$callDuration sec"
    } else {
        val minutes = callDuration / 60
        val seconds = callDuration % 60
        return "$minutes:$seconds min"
    }
}
