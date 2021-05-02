//
//  AirBrotherUtils.h
//  air_brother
//
//  Created by admin on 5/1/21.
//

#ifndef AirBrotherUtils_h
#define AirBrotherUtils_h

#import <BRScanKit/BRScanDevice.h>
#import <BRScanKit/BRScanJob.h>


@interface AirBrotherUtils : NSObject

+ (NSDictionary<NSString *, NSObject *>*) scanDeviceToConnectorMap:(BRScanDevice *) scanDevice;

+ (BRScanJobOptionColorType) colorTypeFromMap:(NSDictionary<NSString *, NSObject *> *) map;

+ (BRScanJobOptionDocumentSize) documentSizeOptionsFromMap:(NSDictionary<NSString *, NSObject *>*) map;

+ (BRScanJobOptionDuplex) duplexOptionsFromMap:(NSDictionary<NSString *, NSObject *> *) map;

+ (NSDictionary<NSString*, NSObject *> *) scanOptionsFromMap:(NSDictionary<NSString *, NSObject *> *) map;

+ (NSString *) ipAddressFromConnectorMap:(NSDictionary <NSString *, NSObject *> *) map;

+ (NSDictionary<NSString *, NSObject *> *) scanJobResultToMap:(BRScanJobResult) result;
@end

#endif /* AirBrotherUtils_h */
