package com.rouninlabs.air_brother.method

import android.content.Context
import android.util.Log
import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.IConnector
import com.brother.sdk.common.Job
import com.brother.sdk.common.device.CountrySpec
import com.brother.sdk.common.device.scanner.ScanPaperSource
import com.brother.sdk.network.NetworkControllerManager
import com.brother.sdk.scan.ScanJob
import com.brother.sdk.scan.ScanJobController
import com.brother.sdk.scan.ScanParameters
import com.brother.sdk.usb.discovery.UsbConnectorDiscovery
import com.rouninlabs.air_brother.BrotherManager
import com.rouninlabs.air_brother.connectorFromMap
import com.rouninlabs.air_brother.scanParamsFromMap
import com.rouninlabs.air_brother.toMap
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*


/**
 * Command for querying the USB Brother Devices.
 */
class PerformScanMethodCall(val context: Context, val call: MethodCall, val result: MethodChannel.Result) {
    companion object {
        const val METHOD_NAME = "performScan"
    }

    fun execute() {

        GlobalScope.launch(Dispatchers.IO) {

            val dartConnector = call.argument<Map<String, Any>>("connector")!!
            val dartScanParams = call.argument<Map<String, Any>>("scanParams")!!

            var jobState:Job.JobState = Job.JobState.SuccessJob
            val scannedFiles: MutableList<String> = arrayListOf()
            val connector = connectorFromMap(dartConnector)
            
            if (connector == null) {
                // Return with error
                jobState = Job.JobState.ErrorJob
                withContext(Dispatchers.Main) {
                    // Set result Printer status.
                    result.success(hashMapOf(
                            "jobState" to jobState.toMap(),
                            "scannedPaths" to  scannedFiles
                    ))
                }
                return@launch
                
            }
            
            // Perform scan
            val scanParameters:ScanParameters = scanParamsFromMap(dartScanParams)

            try {
                val mScanJob =
                        ScanJob(scanParameters, context, object : ScanJobController(context.filesDir) {
                            // The "value" is progress value in scan processing which is between 0 to 100 per page.
                            override fun onUpdateProcessProgress(value: Int) {}

                            // This callback would not be called if any response has not come from our device.
                            override fun onNotifyProcessAlive() {}

                            // This callback would be called when scanned image has been retained.
                            override fun onImageReadToFile(
                                    scannedImagePath: String,
                                    pageIndex: Int
                            ) {
                                Log.e("Frank", "Scanned File $scannedImagePath")
                                scannedFiles.add(scannedImagePath)
                            }
                        })
                // [Brother Comment]
                // The process has been executed synchronously, so in almost cases you should implement the call of IConnector.submit(ScanJob) in Thread.
                jobState = connector.submit(mScanJob)
            }
            catch (e: Exception) {

            }
            finally {
                val fJobState: Job.JobState = jobState
                if (fJobState == Job.JobState.SuccessJob) {
                    Log.e("Frank", "Scanned Files $scannedFiles")
                }

                withContext(Dispatchers.Main) {
                    // Set result Printer status.
                    result.success(hashMapOf(
                            "jobState" to jobState.toMap(),
                            "scannedPaths" to  scannedFiles
                    ))
                }

            }

        }
    }
}