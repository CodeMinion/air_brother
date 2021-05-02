//
//  GetNetworkDevicesMethodCall.h
//  air_brother
//
//  Created by admin on 5/1/21.
//

#ifndef GetNetworkDevicesMethodCall_h
#define GetNetworkDevicesMethodCall_h

#import <Flutter/Flutter.h>
#import <BRScanKit/BRScanDevice.h>
#import <BRScanKit/BRScanDeviceBrowser.h>
#import "AirBrotherUtils.h"

@interface GetNetworkDevicesMethodCall : NSObject<BRScanDeviceBrowserDelegate>

@property (strong, nonatomic) FlutterMethodCall* call;
@property (strong, nonatomic) FlutterResult result;
@property (class, nonatomic, assign, readonly) NSString * METHOD_NAME;

@property (strong, nonatomic) BRScanDeviceBrowser * deviceBrowser;
@property (strong, nonatomic) NSMutableArray<BRScanDevice *> * foundDevices;

- (instancetype)initWithCall:(FlutterMethodCall *)call
                  result:(FlutterResult) result;

- (void) execute;
@end

#endif /* GetNetworkDevicesMethodCall_h */
