package com.rouninlabs.air_brother

import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.ContentType
import com.brother.sdk.common.IConnector
import com.brother.sdk.common.Job
import com.brother.sdk.common.device.*
import com.brother.sdk.common.device.MediaSize.fromName
import com.brother.sdk.common.device.printer.*
import com.brother.sdk.common.device.scanner.ScanPaperSource
import com.brother.sdk.common.device.scanner.ScanSpecialMode
import com.brother.sdk.print.PrintParameters
import com.brother.sdk.scan.ScanParameters

fun IConnector.getConnectorId(): Int {
    return connectorIdentifier.hashCode()
}

fun Pair<ConnectorDescriptor, IConnector>.toMap(): Map<String, Any> {
    return hashMapOf(
            "id" to second.getConnectorId(),
            "descriptorIdentifier" to first.descriptorIdentifier,
            "modelName" to first.modelName,
            "faxSupported" to (second.device.fax != null),
            "isPrintSupported" to (second.device.printer != null),
            "isScanSupported" to (second.device.scanner != null)
    )
}

fun Job.JobState.toMap(): Map<String, Any> {
    return hashMapOf(
            "name" to name
    )
}

fun connectorFromMap(map: Map<String, Any>): IConnector? {
    val connectorId = map["id"] as Int
    val connector = BrotherManager.getConnector(connectorId)
    return connector
}


fun scanParamsFromMap(map: Map<String, Any>): ScanParameters {
    return ScanParameters().apply {
        documentSize = mediaSizeFromMap(map["documentSize"] as Map<String, Any>)
        duplex = duplexFromMap(map["duplex"] as Map<String, Any>)
        colorType = colorProcessingFromMap(map["colorType"] as Map<String, Any>)
        resolution = resolutionFromMap(map["resolution"] as Map<String, Any>)
        paperSource = scanPaperSourceFromMap(map["paperSource"] as Map<String, Any>)
        autoDocumentSizeScan = map["autoDocumentSizeScan"] as Boolean
        whitePageRemove = map["whitePageRemove"] as Boolean
        groundColorCorrection = map["groundColorCorrection"] as Boolean
        specialScanMode = scanSpecialModeFromMap(map["specialScanMode"] as Map<String, Any>)
    }
}

fun mediaSizeFromMap(map: Map<String, Any>): MediaSize {
    val name: String = map["name"] as String
    return MediaSize.fromName(name)
}

fun duplexFromMap(map: Map<String, Any>): Duplex {
    val name = map["name"] as String
    return Duplex.valueOf(name)
}

fun colorProcessingFromMap(map: Map<String, Any>): ColorProcessing {
    val name: String = map["name"] as String
    return ColorProcessing.valueOf(name);
}

fun resolutionFromMap(map: Map<String, Any>): Resolution {
    val width = map["width"] as Int
    val height = map["height"] as Int
    return Resolution(width, height);
}

fun scanPaperSourceFromMap(map: Map<String, Any>): ScanPaperSource {
    val value = map["value"] as Int
    return ScanPaperSource.fromValue(value);
}

fun scanSpecialModeFromMap(map: Map<String, Any>): ScanSpecialMode {
    val value = map["value"] as Int
    return ScanSpecialMode.fromValue(value);
}

fun printParamsFromMap(map: Map<String, Any>): PrintParameters {
    return PrintParameters().apply {
        paperSize = mediaSizeFromMap(map["paperSize"] as Map<String, Any>)
        mediaType = (null as PrintMediaType?).fromMap(map["mediaType"] as Map<String, Any>)
        duplex = duplexFromMap(map["duplex"] as Map<String, Any>)
        color = (null as ColorProcessing?).fromMap(map["color"] as Map<String, Any>)
        orientation = (null as PrintOrientation?).fromMap(map["orientation"] as Map<String, Any>)
        scale = (null as PrintScale?).fromMap(map["scale"] as Map<String, Any>)
        quality = (null as PrintQuality?).fromMap(map["quality"] as Map<String, Any>)
        resolution = resolutionFromMap(map["resolution"] as Map<String, Any>)
        margin = (null as PrintMargin?).fromMap(map["margin"] as Map<String, Any>)
        printContent = (null as ContentType?).fromMap(map["printContent"] as Map<String, Any>)
        copyCount = map["copyCount"] as Int
        collate = (null as PrintCollate?).fromMap(map["collate"] as Map<String, Any>)
        colorMatching = (null as PrintColorMatching?).fromMap(map["colorMatching"] as Map<String, Any>)
        origin = (null as PrintOrigin?).fromMap(map["origin"] as Map<String, Any>)
        customScaling = (null as PrintCustomScaling?).fromMap(map["customScaling"] as Map<String, Any>)
        directPrinting = map["directPrinting"] as Boolean
    }
}

fun PrintMediaType?.fromMap(map: Map<String, Any>): PrintMediaType {
    val name: String = map["name"] as String
    return PrintMediaType.valueOf(name)
}

fun ColorProcessing?.fromMap(map: Map<String, Any>): ColorProcessing {
    val name = map["name"] as String
    return ColorProcessing.valueOf(name);
}

fun PrintOrientation?.fromMap(map: Map<String, Any>): PrintOrientation {
    val name = map["name"] as String
    return PrintOrientation.valueOf(name);
}

fun PrintScale?.fromMap(map: Map<String, Any>): PrintScale {
    val name = map["name"] as String
    return PrintScale.valueOf(name);
}

fun PrintQuality?.fromMap(map: Map<String, Any>): PrintQuality {
    val name = map["name"] as String
    return PrintQuality.valueOf(name);
}

fun PrintMargin?.fromMap(map: Map<String, Any>): PrintMargin {
    val name = map["name"] as String
    return PrintMargin.valueOf(name);
}

fun ContentType?.fromMap(map: Map<String, Any>): ContentType {
    val name = map["name"] as String
    return ContentType.valueOf(name);
}

fun PrintCollate?.fromMap(map: Map<String, Any>): PrintCollate {
    val name = map["name"] as String
    return PrintCollate.valueOf(name);
}

fun PrintColorMatching?.fromMap(map: Map<String, Any>): PrintColorMatching {
    val name = map["name"] as String
    return PrintColorMatching.valueOf(name);
}

fun PrintOrigin?.fromMap(map: Map<String, Any>): PrintOrigin {
    val x = map["inchX"] as Double
    val y = map["inchX"] as Double

    return PrintOrigin(x, y);
}

fun PrintCustomScaling?.fromMap(map: Map<String, Any>): PrintCustomScaling {
    return PrintCustomScaling(
            map["scaleX"] as Double,
            map["scaleY"] as Double,
            (null as HorizontalAlignment?).fromMap(map["hAlignment"] as Map<String, Any>),
            (null as VerticalAlignment?).fromMap(map["vAlignment"] as Map<String, Any>)
    )
}

fun HorizontalAlignment?.fromMap(map: Map<String, Any>): HorizontalAlignment {
    val name = map["name"] as String
    return HorizontalAlignment.valueOf(name);
}

fun VerticalAlignment?.fromMap(map: Map<String, Any>): VerticalAlignment {
    val name = map["name"] as String
    return VerticalAlignment.valueOf(name);
}
