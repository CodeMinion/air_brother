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

@end
