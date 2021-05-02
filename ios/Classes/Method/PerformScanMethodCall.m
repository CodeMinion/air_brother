//
//  PerformScanMethodCall.m
//  air_brother
//
//  Created by admin on 5/2/21.
//

#import <Foundation/Foundation.h>
#import "PerformScanMethodCall.h"

@implementation PerformScanMethodCall


static NSString * METHOD_NAME = @"performScan";

- (instancetype)initWithCall:(FlutterMethodCall *)call
                      result:(FlutterResult) result {
    self = [super init];
        if (self) {
            _call = call;
            _result = result;
            
        }
        return self;
}

+ (NSString *) METHOD_NAME {
    return METHOD_NAME;
}
- (void)execute {
 
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            
            // TODO Get paramters
            NSDictionary<NSString*, NSObject*> * dartConnector = self->_call.arguments[@"connector"];
            NSDictionary<NSString *, NSObject *> * dartScanParams = self->_call.arguments[@"scanParams"];
            
            NSString * ipAddress = [AirBrotherUtils ipAddressFromConnectorMap:dartConnector];
            NSDictionary<NSString *, NSObject *> * scanParams = [AirBrotherUtils scanOptionsFromMap:dartScanParams];
            
            //self->_scanningDevice = [BRScanDevice deviceWithIPAddress:ipAddress];
            self->_scanJob = [[BRScanJob alloc] initWithIPAddress:ipAddress];
            [self->_scanJob setDelegate:self];
            [self->_scanJob setOptions:scanParams];
            [self->_scanJob start];
            
            
            // Wait for timeout (Time interval is expected in seconds)
            //[NSThread sleepForTimeInterval:[timeout intValue]/1000];
            // Stop search
            //[self->_deviceBrowser stop];
            // Map the found devices to connectors.
            //NSMutableArray<NSDictionary<NSString *, NSObject*> *> * dartNetScanners = [NSMutableArray arrayWithCapacity:[self->_foundDevices count]];
            
            //[self->_foundDevices enumerateObjectsUsingBlock:^(id scanner, NSUInteger idx, BOOL *stop) {
            //    id mapObj = [AirBrotherUtils scanDeviceToConnectorMap:scanner];
            //    [dartNetScanners addObject:mapObj];
            //}];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // Update UI
                        // Call the desired channel message here.
                        //self->_result(dartNetScanners);
                    });
             
        });
    
    
    
}

- (void)scanJobDidFinishJob:(BRScanJob *)job result:(BRScanJobResult)result {
    
    // TODO Notify flutter. scannedPaths
    dispatch_sync(dispatch_get_main_queue(), ^{
        // Update UI
        // Call the desired channel message here.
        NSDictionary<NSString *, NSObject *> * dartPaths = @{
            @"jobState": [AirBrotherUtils scanJobResultToMap:result], // TODO encode result
            @"scannedPaths": [job filePaths]
        };
        
        self->_result(dartPaths);
    });
}

- (void)scanJob:(BRScanJob *)job didFinishPage:(NSString *)path {
    // TODO Add page
    [_scannedPagesPaths addObject:path];
}

@end
