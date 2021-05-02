//
//  AirBrotherUtils.m
//  air_brother
//
//  Created by admin on 5/1/21.
//

#import <Foundation/Foundation.h>
#import "AirBrotherUtils.h"

@implementation AirBrotherUtils

+ (NSDictionary<NSString *, NSObject *>*) scanDeviceToConnectorMap:(BRScanDevice *) scanDevice {
    
    NSDictionary<NSString *, NSObject *> * dartConnector = @{
        @"id": [NSNumber numberWithInt:[[scanDevice IPAddress] hash]], // TODO
        @"descriptorIdentifier": [scanDevice IPAddress],
        @"modelName": [scanDevice modelName],
        @"faxSupported": [NSNumber numberWithBool:false], // TODO Link with capabilities
        @"isPrintSupported": [NSNumber numberWithBool:false], // TODO Link with capabilities
        @"isScanSupported": [NSNumber numberWithBool:[[[scanDevice capability] objectForKey:BRScanDeviceCapabilityIsScannerAvailableKey] isEqual:@(YES)]] // TODO Link with capabilities
        
    };
    
    return dartConnector;
}

+ (BRScanJobOptionColorType)colorTypeFromMap:(NSDictionary<NSString *,NSObject *> *)map {
    NSString * colorTypeName = (NSString *)[map objectForKey:@"name"];
    
    if ([colorTypeName isEqualToString:@"BlackAndWhite"]) {
        return BRScanJobOptionColorTypeColorHighSpeed;
    }
    else if ([colorTypeName isEqualToString:@"Grayscale"]) {
        return BRScanJobOptionColorTypeGrayscale;
    }
    else if ([colorTypeName isEqualToString:@"FullColor"]) {
        return BRScanJobOptionColorTypeColor;
    }
    
    return BRScanJobOptionColorTypeColor;
}

+ (BRScanJobOptionDocumentSize)documentSizeOptionsFromMap:(NSDictionary<NSString *,NSObject *> *)map {
    NSString * documentSizeName = (NSString *) [map objectForKey:@"name"];
    
    if ([documentSizeName isEqualToString:@"iso_a3_297x420mm"]) {
        return BRScanJobOptionDocumentSizeA3;
    }
    else if ([documentSizeName isEqualToString:@"iso_a4_210x297mm"]) {
        return BRScanJobOptionDocumentSizeA4;
    }
    else if ([documentSizeName isEqualToString:@"iso_a5_148x210mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_a6_105x148mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_b4_250x353mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_b5_176x250mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_b6_125x176mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_c5_162x229mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"iso_dl_110x220mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"na_letter_8"]) {
        return BRScanJobOptionDocumentSizeLetter;
    }
    else if ([documentSizeName isEqualToString:@"na_legal_8"]) {
        return BRScanJobOptionDocumentSizeLegal;
    }
    else if ([documentSizeName isEqualToString:@"na_ledger_11x17in"]) {
        return BRScanJobOptionDocumentSizeLedger;
    }
    else if ([documentSizeName isEqualToString:@"na_index"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"na_5x7_5x7in"]) {
        return BRScanJobOptionDocumentSizePhoto;
    }
    else if ([documentSizeName isEqualToString:@"na_executive_7.25x10.5in"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"jis_b4_257x364mm"]) {
        return BRScanJobOptionDocumentSizeJISB4;
    }
    else if ([documentSizeName isEqualToString:@"jis_b5_182x257mm"]) {
        return BRScanJobOptionDocumentSizeJISB5;
    }
    else if ([documentSizeName isEqualToString:@"jpn_hagaki_100x148mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"oe_photo-l_3.5x5in"]) {
        return BRScanJobOptionDocumentSizePhotoL;
    }
    else if ([documentSizeName isEqualToString:@"om_folio_210x330mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"custom_card_60x90mm"]) {
        return BRScanJobOptionDocumentSizeBusinessCard;
    }
    else if ([documentSizeName isEqualToString:@"custom_card-land_90x60mm"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    else if ([documentSizeName isEqualToString:@"custom_undefined_0x0in"]) {
        return BRScanJobOptionDocumentSizeAuto;
    }
    return BRScanJobOptionDocumentSizeAuto;

}

+ (BRScanJobOptionDuplex)duplexOptionsFromMap:(NSDictionary<NSString *,NSObject *> *)map {
    
    NSString * duplexOptionName = (NSString *) [map objectForKey:@"name"];
    
    if ([duplexOptionName isEqualToString:@"Simplex"]) {
        return BRScanJobOptionDuplexOff;
    }
    else if ([duplexOptionName isEqualToString:@"FlipOnLongEdge"]) {
        return BRScanJobOptionDuplexLongEdge;
    }
    else if ([duplexOptionName isEqualToString:@"FlipOnShortEdge"]) {
        return BRScanJobOptionDuplexShortEdge;
    }
    
    return BRScanJobOptionDuplexOff;
}

+ (NSDictionary<NSString *,NSObject *> *)scanOptionsFromMap:(NSDictionary<NSString *,NSObject *> *)map {
    
    NSDictionary<NSString *, NSObject *> * dartDocumentSize = (NSDictionary<NSString *, NSObject *> *)[map objectForKey:@"documentSize"];
    
    NSDictionary<NSString *, NSObject *> * dartDuplex = (NSDictionary<NSString *, NSObject *> *)[map objectForKey:@"duplex"];
    
    NSDictionary<NSString *, NSObject *> * dartColorType = (NSDictionary<NSString *, NSObject *> *)[map objectForKey:@"colorType"];
    
    
    NSDictionary<NSString *, NSObject *> * scanOptions = @{
        BRScanJobOptionColorTypeKey: @([AirBrotherUtils colorTypeFromMap:dartColorType]),
        BRScanJobOptionDocumentSizeKey: @([AirBrotherUtils documentSizeOptionsFromMap:dartDocumentSize]),
        BRScanJobOptionDuplexKey: @([AirBrotherUtils duplexOptionsFromMap:dartDuplex]),
        //BRScanJobOptionSkipBlankPageKey: @(YES)
        //BRScanJobOptionUseVirtualScanModeKey: // TODO No Android equivalent
        //BRScanJobOptionVirtualScanPageCountKey
        //BRScanJobOptionVirtualScanPageIntervalKey
        
        
    };
    /*
     "documentSize": documentSize.toMap(),
           "duplex": duplex.toMap(),
           "colorType": colorType.toMap(),
           "resolution": resolution.toMap(), // Not supported
           "paperSource": paperSource.toMap(), //  Not supported
           "autoDocumentSizeScan": autoDocumentSizeScan, (bool)
           "whitePageRemove": whitePageRemove, (bool)
           "groundColorCorrection": groundColorCorrection, (bool)
           "specialScanMode": specialScanMode.toMap()
     */
    
    return scanOptions;
}

+ (NSString *)ipAddressFromConnectorMap:(NSDictionary<NSString *,NSObject *> *)map {
    NSString * ipAddress = (NSString *)[map objectForKey:@"descriptorIdentifier"];
    
    return ipAddress;
}


+ (NSDictionary<NSString *,NSObject *> *)scanJobResultToMap:(BRScanJobResult )result {
    NSString * resultName = @"SuccessJob";
    
    if (result == BRScanJobResultSuccess) {
        resultName = @"SuccessJob";
    }
    else if (result == BRScanJobResultFail) {
        resultName = @"ErrorJob";
    }
    else if (result == BRScanJobResultCancel) {
        resultName = @"ErrorJobCancel";
    }
    
    NSDictionary<NSString *, NSObject *> * dartScanResult =  @{
        @"name": resultName
    };
    
    return dartScanResult;
}
@end
