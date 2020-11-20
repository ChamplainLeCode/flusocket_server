#import "FlusocketServerPlugin.h"
#if __has_include(<flusocket_server/flusocket_server-Swift.h>)
#import <flusocket_server/flusocket_server-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flusocket_server-Swift.h"
#endif

@implementation FlusocketServerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlusocketServerPlugin registerWithRegistrar:registrar];
}
@end
