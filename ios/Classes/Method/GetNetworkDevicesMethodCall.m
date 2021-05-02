//
//  GetNetworkDevicesMethodCall.m
//  air_brother
//
//  Created by admin on 5/1/21.
//

#import <Foundation/Foundation.h>
#import "GetNetworkDevicesMethodCall.h"

@implementation GetNetworkDevicesMethodCall

static NSString * METHOD_NAME = @"getNetworkDevices";

- (instancetype)initWithCall:(FlutterMethodCall *)call
                      result:(FlutterResult) result {
    self = [super init];
        if (self) {
            _call = call;
            _result = result;
            _foundDevices = [[NSMutableArray<BRScanDevice *> alloc] init];
            
        }
        return self;
}

+ (NSString *) METHOD_NAME {
    return METHOD_NAME;
}

- (void)execute {

    
    _deviceBrowser = [BRScanDeviceBrowser alloc];
    [_deviceBrowser setDelegate:self];
    // Start Search
    [_deviceBrowser search];
    
    
    NSNumber * timeout = self->_call.arguments[@"timeout"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            // Wait for timeout (Time interval is expected in seconds)
            [NSThread sleepForTimeInterval:[timeout intValue]/1000];
            // Stop search
            [self->_deviceBrowser stop];
            // Map the found devices to connectors.
            NSMutableArray<NSDictionary<NSString *, NSObject*> *> * dartNetScanners = [NSMutableArray arrayWithCapacity:[self->_foundDevices count]];
            
            [self->_foundDevices enumerateObjectsUsingBlock:^(id scanner, NSUInteger idx, BOOL *stop) {
                id mapObj = [AirBrotherUtils scanDeviceToConnectorMap:scanner];
                [dartNetScanners addObject:mapObj];
            }];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // Update UI
                        // Call the desired channel message here.
                        self->_result(dartNetScanners);
                    });
             
        });
    
    
}

- (void)scanDeviceBrowser:(BRScanDeviceBrowser *)browser didFindDevice:(BRScanDevice *)device {
    [_foundDevices addObject:device];
}

- (void)scanDeviceBrowser:(BRScanDeviceBrowser *)browser didRemoveDevice:(BRScanDevice *)device {
    // Do nothing
}


@end
