package com.rouninlabs.air_brother.method

import android.content.Context
import android.util.Log
import com.brother.sdk.common.Callback
import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.IConnector
import com.brother.sdk.common.Job
import com.brother.sdk.common.device.CountrySpec
import com.brother.sdk.common.device.scanner.ScanPaperSource
import com.brother.sdk.network.NetworkControllerManager
import com.brother.sdk.print.PrintJob
import com.brother.sdk.print.PrintParameters
import com.brother.sdk.scan.ScanJob
import com.brother.sdk.scan.ScanJobController
import com.brother.sdk.scan.ScanParameters
import com.brother.sdk.usb.discovery.UsbConnectorDiscovery
import com.rouninlabs.air_brother.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.File


/**
 * Command for performing a print.
 */
class PerformPrintMethodCall(val context: Context, val call: MethodCall, val result: MethodChannel.Result) {
    companion object {
        const val METHOD_NAME = "performPrint"
    }

    fun execute() {

        GlobalScope.launch(Dispatchers.IO) {

            val dartConnector = call.argument<Map<String, Any>>("connector")!!
            val pathsToPrint = call.argument<List<String>>("filePaths")!!
            val dartPrintParams = call.argument<Map<String, Any>>("printParams")!!

            var jobState:Job.JobState = Job.JobState.SuccessJob
            val connector = connectorFromMap(dartConnector)
            
            if (connector == null) {
                // Return with error
                jobState = Job.JobState.ErrorJob
                withContext(Dispatchers.Main) {
                    // Set result Printer status.
                    result.success(jobState.toMap())
                }
                return@launch
                
            }
            
            // Perform print
            val printParameters:PrintParameters = printParamsFromMap(dartPrintParams)

            try {
                val mPrintJob =
                        PrintJob(printParameters, context, pathsToPrint.map { File(it) }, object : Callback() {
                            // The "value" is progress value in scan processing which is between 0 to 100 per page.
                            override fun onUpdateProcessProgress(value: Int) {}

                            // This callback would not be called if any response has not come from our device.
                            override fun onNotifyProcessAlive() {}

                        })
                // [Brother Comment]
                // The process has been executed synchronously, so in almost cases you should implement the call of IConnector.submit(ScanJob) in Thread.
                jobState = connector.submit(mPrintJob)
            }
            catch (e: Exception) {

            }
            finally {
                val fJobState: Job.JobState = jobState
                if (fJobState == Job.JobState.SuccessJob) {
                    Log.e("Frank", "Printed Files $pathsToPrint")
                }

                withContext(Dispatchers.Main) {
                    // Set result Printer status.
                    result.success(jobState.toMap())
                }

            }

        }
    }
}