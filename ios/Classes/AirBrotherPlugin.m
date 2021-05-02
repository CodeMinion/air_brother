#import "AirBrotherPlugin.h"
#if __has_include(<air_brother/air_brother-Swift.h>)
//#import <air_brother/air_brother-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
//#import "air_brother-Swift.h"
#endif

#import <BRScanKit/BRScanKit.h>
#import "Method/GetNetworkDevicesMethodCall.h"
#import "Method/PerformScanMethodCall.h"

@implementation AirBrotherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  //[SwiftAirBrotherPlugin registerWithRegistrar:registrar];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"air_brother" binaryMessenger:[registrar messenger]];
    AirBrotherPlugin* instance = [AirBrotherPlugin new];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([NSString stringWithFormat:@"iOS %@", UIDevice.currentDevice.systemVersion]);
    }
    else if ([[GetNetworkDevicesMethodCall METHOD_NAME] isEqualToString:call.method]) {
        // Track the call so it doesn't get collected before we are done.
        _lastNetPrinterCall = [[GetNetworkDevicesMethodCall alloc] initWithCall:call result:result];
        [(GetNetworkDevicesMethodCall *)_lastNetPrinterCall execute];
        
    }
    else if ([[PerformScanMethodCall METHOD_NAME] isEqualToString:call.method]) {
        // Track the call so it doesn't get collected before we are done.
        _lastScanCall = [[PerformScanMethodCall alloc] initWithCall:call result:result];
        [(PerformScanMethodCall *)_lastScanCall execute];
        
    }
    else {
          result(FlutterMethodNotImplemented);
    }
    
}

@end
