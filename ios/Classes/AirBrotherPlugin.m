#import "AirBrotherPlugin.h"
#if __has_include(<air_brother/air_brother-Swift.h>)
#import <air_brother/air_brother-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "air_brother-Swift.h"
#endif

@implementation AirBrotherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAirBrotherPlugin registerWithRegistrar:registrar];
}
@end
