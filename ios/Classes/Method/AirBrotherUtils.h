//
//  AirBrotherUtils.h
//  air_brother
//
//  Created by admin on 5/1/21.
//

#ifndef AirBrotherUtils_h
#define AirBrotherUtils_h

#import <BRScanKit/BRScanDevice.h>


@interface AirBrotherUtils : NSObject

+ (NSDictionary<NSString *, NSObject *>*) scanDeviceToConnectorMap:(BRScanDevice *) scanDevice;

@end

#endif /* AirBrotherUtils_h */
