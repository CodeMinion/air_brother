package com.rouninlabs.air_brother.method

import android.content.Context
import android.util.Log
import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.IConnector
import com.brother.sdk.common.device.CountrySpec
import com.brother.sdk.network.NetworkControllerManager
import com.brother.sdk.usb.discovery.UsbConnectorDiscovery
import com.rouninlabs.air_brother.BrotherManager
import com.rouninlabs.air_brother.toMap
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*


/**
 * Command for querying the USB Brother Devices.
 */
class GetUsbDevicesMethodCall(val context: Context, val call: MethodCall, val result: MethodChannel.Result) {
    companion object {
        const val METHOD_NAME = "getUsbDevices"
    }

    fun execute() {

        GlobalScope.launch(Dispatchers.IO) {

            val timeout: Long = call.argument<Long>("timeout")!!

            val foundDevices: MutableList<Pair<ConnectorDescriptor, IConnector>> = arrayListOf()
            val foundDescriptors:MutableSet<ConnectorDescriptor> = hashSetOf()

            val usbDiscovery = UsbConnectorDiscovery()

            usbDiscovery.startDiscover{ descriptor->

                if (descriptor.support(ConnectorDescriptor.Function.Scan)
                        || descriptor.support(ConnectorDescriptor.Function.Print)) {

                    Log.e("Frank", "Found Device: ${(descriptor as ConnectorDescriptor).modelName}")

                    if (!foundDescriptors.contains(descriptor)) {

                        val connector = descriptor.createConnector(
                        CountrySpec.fromISO_3166_1_Alpha2(
                                context.getResources().getConfiguration().locale.getCountry()
                        ))

                        connector?.let {
                            foundDevices.add(Pair<ConnectorDescriptor, IConnector> (descriptor, it))
                            BrotherManager.trackConnector(it)
                            Log.e("Frank", "Found Device: ${(descriptor as ConnectorDescriptor).modelName}")
                            foundDescriptors.add(descriptor)
                        }
                    }
                }
            }

            delay(timeMillis = timeout)

            usbDiscovery.stopDiscover()

            val dartList:List<Map<String, Any>> = foundDevices.map {
                Log.e("Frank", "Sending ${it.toMap()}")
                it.toMap() }.toList()

            Log.e("Frank", "Sending ${dartList}")

            withContext(Dispatchers.Main) {
                // Set result Printer status.
                result.success(dartList)
            }
        }
    }
}