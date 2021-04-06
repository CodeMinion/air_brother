package com.rouninlabs.air_brother

import com.brother.sdk.common.ConnectorDescriptor
import com.brother.sdk.common.IConnector

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