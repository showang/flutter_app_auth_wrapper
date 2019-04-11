#import "FlutterAppAuthWrapperPlugin.h"
#import <flutter_app_auth_wrapper/flutter_app_auth_wrapper-Swift.h>

@implementation FlutterAppAuthWrapperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAppAuthWrapperPlugin registerWithRegistrar:registrar];
}
@end
