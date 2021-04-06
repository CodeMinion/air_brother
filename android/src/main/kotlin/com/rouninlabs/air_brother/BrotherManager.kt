package com.rouninlabs.air_brother

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import androidx.annotation.WorkerThread
import com.brother.sdk.common.IConnector
import com.rouninlabs.air_brother.receiver.AirBrotherUsbPermissionsReceiver
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.BlockingQueue

/**
 * Tracker active printers to support the open/print/close approach.
 */
object BrotherManager {

    val mTrackedConnectors:MutableMap<Int, IConnector> = hashMapOf()
    val mUsbPermissionRequests: MutableMap<Int, BlockingQueue<Boolean>> = hashMapOf()

    fun trackConnector(connector:IConnector) {
        mTrackedConnectors.put(connector.getConnectorId(), connector);
    }

    fun untrackConnector(connector: IConnector) {
        mTrackedConnectors.remove(connector.getConnectorId())
    }

    /**
     * Makes a permission request to get access to the usb device
     */
    @WorkerThread
    fun requestUsbPermission(context: Context, usbManager: UsbManager, usbDevice: UsbDevice) : Boolean {//:BlockingQueue<Boolean> {
        val requestId = usbDevice.deviceId
        if (mUsbPermissionRequests.containsKey(requestId)) {
            return mUsbPermissionRequests[requestId]!!.take()
        }

        val completableFuture = ArrayBlockingQueue<Boolean>(1)
        mUsbPermissionRequests.put(requestId, completableFuture)
        val intent = Intent(context, AirBrotherUsbPermissionsReceiver::class.java)
        usbManager.requestPermission(usbDevice, PendingIntent.getBroadcast(context, 5676, intent, 0))
        return completableFuture.take()
    }

    fun completePermissionRequest(usbDevice: UsbDevice, granted:Boolean) {
        val requestId = usbDevice.deviceId
        if (!mUsbPermissionRequests.containsKey(requestId)) {
            return
        }

       mUsbPermissionRequests[requestId]?.put(granted)
        mUsbPermissionRequests.remove(requestId)

    }

}
