package com.rouninlabs.air_brother

import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.IConnector
import com.brother.sdk.common.Job
import com.brother.sdk.common.device.ColorProcessing
import com.brother.sdk.common.device.Duplex
import com.brother.sdk.common.device.MediaSize
import com.brother.sdk.common.device.MediaSize.fromName
import com.brother.sdk.common.device.Resolution
import com.brother.sdk.common.device.scanner.ScanPaperSource
import com.brother.sdk.common.device.scanner.ScanSpecialMode
import com.brother.sdk.scan.ScanParameters

fun IConnector.getConnectorId():Int {
    return connectorIdentifier.hashCode()
}

fun Pair<ConnectorDescriptor, IConnector>.toMap():Map<String, Any> {
    return hashMapOf(
            "id" to second.getConnectorId(),
            "descriptorIdentifier" to first.descriptorIdentifier,
            "modelName" to  first.modelName,
            "faxSupported" to (second.device.fax != null),
            "isPrintSupported" to (second.device.printer != null),
            "isScanSupported" to (second.device.scanner != null)
    )
}

fun Job.JobState.toMap():Map<String, Any> {
    return hashMapOf(
            "name" to name
    )
}

fun connectorFromMap(map:Map<String, Any> ):IConnector? {
    val connectorId = map["id"] as Int
    val connector = BrotherManager.getConnector(connectorId)
    return connector
}


fun scanParamsFromMap(map:Map<String, Any>):ScanParameters {
    return ScanParameters().apply {
        documentSize =  mediaSizeFromMap(map["documentSize"] as Map<String, Any>)
        duplex =  duplexFromMap(map["duplex"] as Map<String, Any>)
        colorType =  colorProcessingFromMap(map["colorType"] as Map<String, Any>)
        resolution = resolutionFromMap(map["resolution"] as Map<String, Any>)
        paperSource = scanPaperSourceFromMap(map["paperSource"] as Map<String, Any>)
        autoDocumentSizeScan = map["autoDocumentSizeScan"] as Boolean
        whitePageRemove = map["whitePageRemove"] as Boolean
        groundColorCorrection =  map["groundColorCorrection"] as Boolean
        specialScanMode = scanSpecialModeFromMap(map["specialScanMode"] as Map<String, Any>)
    }
}

fun mediaSizeFromMap(map:Map<String, Any>):MediaSize {
    val name: String = map["name"] as String
    return MediaSize.fromName(name)
}

fun duplexFromMap(map:Map<String, Any>):Duplex {
    val name = map["name"] as String
    return Duplex.valueOf(name)
}

fun colorProcessingFromMap(map: Map<String, Any>):ColorProcessing {
    val name:String = map["name"] as String
    return ColorProcessing.valueOf(name);
}

fun resolutionFromMap(map:Map<String, Any>):Resolution {
    val width = map["width"] as Int
    val height = map["height"] as Int
    return Resolution(width, height);
}

fun scanPaperSourceFromMap(map:Map<String, Any>):ScanPaperSource {
    val value = map["value"] as Int
    return ScanPaperSource.fromValue(value);
}

fun scanSpecialModeFromMap(map:Map<String, Any>):ScanSpecialMode {
    val value = map["value"] as Int
    return ScanSpecialMode.fromValue(value);
}