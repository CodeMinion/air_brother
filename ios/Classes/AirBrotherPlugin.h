#import <Flutter/Flutter.h>

@interface AirBrotherPlugin : NSObject<FlutterPlugin>

@property (strong, nonatomic) id<NSObject> lastNetPrinterCall;

@property (strong, nonatomic) id<NSObject> lastScanCall;

@end
