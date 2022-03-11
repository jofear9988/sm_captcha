#import "SmCaptchaPlugin.h"
#if __has_include(<sm_captcha/sm_captcha-Swift.h>)
#import <sm_captcha/sm_captcha-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sm_captcha-Swift.h"
#endif

@implementation SmCaptchaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmCaptchaPlugin registerWithRegistrar:registrar];
}
@end
