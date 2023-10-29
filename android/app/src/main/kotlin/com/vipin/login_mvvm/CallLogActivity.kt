package com.vipin.login_mvvm

import CallLogModel
import android.Manifest.permission.*
import android.annotation.SuppressLint
import android.app.Dialog
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.app.ActivityCompat
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.mvvmarchitecture.Adapters.MainAdapter
import com.example.mvvmarchitecture.callLogsViewModel.CallLogViewModel
import com.vipin.login_mvvm.MainActivity.Companion.mainResult
import com.vipin.login_mvvm.databinding.ActivityCallLogBinding
import com.vipin.login_mvvm.utils.OnItemClickListener

class CallLogActivity : AppCompatActivity(), OnItemClickListener {
    private lateinit var viewModel: CallLogViewModel
    private lateinit var logoutButton: Button
    private val PERMISSIONS_REQUEST_CODE = 123

    lateinit var binding: ActivityCallLogBinding
    lateinit var callLogList: ArrayList<CallLogModel>
    lateinit var adapter: MainAdapter


    @SuppressLint("MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityCallLogBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val userName = intent.getStringExtra("userName")

        binding.toolbarTitle.text = userName + "'s Call Logs"

        binding.logoutBtn.setOnClickListener {
            mainResult?.success("logoutUser")
            finish()
        }

        callLogList = ArrayList()
        viewModel = ViewModelProvider(
            this,
            CallLogViewModel.Companion.ViewModelFactory(application)
        ).get(CallLogViewModel::class.java)


        if (checkPermissions()) {
            viewModel.loadCallLogs(this)
        } else {
            requestPermissions()
        }

        viewModel.callLogs.observe(this, Observer { callLogs ->
            callLogList.addAll(callLogs)
            adapter.notifyDataSetChanged()
        })

        binding.recyclerView.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        adapter = MainAdapter(callLogList, this)
        binding.recyclerView.adapter = adapter
    }

    override fun onBackPressed() {
        super.onBackPressed()
        mainResult?.success("backButtonPressed")
    }

    override fun onItemClick(callLogModel: CallLogModel) {
        showCustomDialog(callLogModel.phoneNumber, callLogModel.phoneNumber)
    }

    //    private fun showCustomDialog(phoneNumber: String, textToCopy: String) {
//        if (!isFinishing) {
//            val builder = AlertDialog.Builder(this)
//            builder.setTitle("Options")
//                .setItems(arrayOf("Call", "Copy Number")) { _, which ->
//                    when (which) {
//                        0 -> {
//                            val intent = Intent(Intent.ACTION_DIAL)
//                            intent.data = android.net.Uri.parse("tel:$phoneNumber")
//                            startActivity(intent)
//                        }
//                        1 -> {
//                            val clipboardManager =
//                                getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
//                            clipboardManager.text = textToCopy
//                            Toast.makeText(
//                                this,
//                                "Number copied to clipboard: $textToCopy",
//                                Toast.LENGTH_SHORT
//                            ).show()
//                        }
//                    }
//                }
//
//            val dialog = builder.create()
//            dialog.show()
//        }
//    }
    private fun showCustomDialog(phoneNumber: String, textToCopy: String) {
        if (!isFinishing) {
            val dialog = Dialog(this)
            dialog.setContentView(R.layout.dialog_call_option)
            dialog.window!!.setLayout(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.WRAP_CONTENT
            )
            dialog.window!!.setGravity(Gravity.CENTER)

            val callButton = dialog.findViewById<ConstraintLayout>(R.id.layout_call)
            val closeButton = dialog.findViewById<TextView>(R.id.closeButton)
            val copyButton = dialog.findViewById<ConstraintLayout>(R.id.layout_copy)

            callButton.setOnClickListener {
                val intent = Intent(Intent.ACTION_DIAL)
                intent.data = android.net.Uri.parse("tel:$phoneNumber")
                startActivity(intent)
                dialog.cancel()
            }

            closeButton.setOnClickListener {
                dialog.cancel()
            }

            copyButton.setOnClickListener {
                val clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                clipboardManager.text = textToCopy
                Toast.makeText(this, "Number copied to clipboard: $textToCopy", Toast.LENGTH_SHORT).show()
                dialog.cancel()
            }

            dialog.show()
        }
    }

    private fun checkPermissions(): Boolean {
        val permissions = arrayOf(
            READ_CALL_LOG,
            WRITE_CALL_LOG,
            CALL_PHONE
        )
        for (permission in permissions) {
            if (ActivityCompat.checkSelfPermission(this, permission) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }
        }
        return true
    }

    // Function to request permissions from the user
    private fun requestPermissions() {
        val permissions = arrayOf(
            READ_CALL_LOG,
            WRITE_CALL_LOG,
            CALL_PHONE
        )
        ActivityCompat.requestPermissions(this, permissions, PERMISSIONS_REQUEST_CODE)
    }

    // Handle the result of the permission request
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSIONS_REQUEST_CODE) {
            // Check if all requested permissions are granted
            if (checkPermissions()) {
                // Permissions are granted, load call logs
                viewModel.loadCallLogs(this)
            } else {
                // Permissions are not granted, show a message to the user
                Toast.makeText(
                    this,
                    "Permissions denied. Cannot load call logs.",
                    Toast.LENGTH_SHORT
                ).show()
            }
        }
    }

}
