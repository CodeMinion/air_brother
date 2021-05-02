//
//  PerformScanMethodCall.h
//  air_brother
//
//  Created by admin on 5/2/21.
//

#ifndef PerformScanMethodCall_h
#define PerformScanMethodCall_h

#import <Flutter/Flutter.h>
#import <BRScanKit/BRScanJob.h>
#import <BRScanKit/BRScanDevice.h>
#import "AirBrotherUtils.h"

@interface PerformScanMethodCall : NSObject<BRScanJobDelegate>

@property (strong, nonatomic) FlutterMethodCall* call;
@property (strong, nonatomic) FlutterResult result;
@property (class, nonatomic, assign, readonly) NSString * METHOD_NAME;

//@property (strong, nonatomic) BRScanDevice * scanningDevice;
@property (strong, nonatomic) BRScanJob * scanJob;


@property (strong, nonatomic) NSMutableArray<NSString *> * scannedPagesPaths;

- (instancetype)initWithCall:(FlutterMethodCall *)call
                  result:(FlutterResult) result;

- (void) execute;
@end

#endif /* PerformScanMethodCall_h */
