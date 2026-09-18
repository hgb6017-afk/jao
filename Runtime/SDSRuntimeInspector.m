#import "SDSRuntimeInspector.h"
#import "SDSRuntimeCapabilities.h"
#import "../Utilities/SDSLogger.h"

@interface SDSRuntimeInspector ()
@property(nonatomic, strong, readwrite) SDSRuntimeCapabilities *capabilities;
@end

@implementation SDSRuntimeInspector

- (instancetype)init {
    self = [super init];
    if (self) _capabilities = [[SDSRuntimeCapabilities alloc] init];
    return self;
}

- (void)inspect {
    NSBundle *bundle = NSBundle.mainBundle;
    NSString *bundleID = bundle.bundleIdentifier ?: @"<nil>";
    NSString *executable = bundle.executablePath.lastPathComponent ?: @"<nil>";
    SDSRuntimeVersion *version = self.capabilities.runtimeVersion;
    NSOperatingSystemVersion v = version.operatingSystemVersion;

    self.capabilities.targetSummary = [NSString stringWithFormat:
        @"os=%ld.%ld.%ld family=%@ bundle=%@ executable=%@; private integration not verified",
        (long)v.majorVersion, (long)v.minorVersion, (long)v.patchVersion,
        version.familyName, bundleID, executable];

    // No private class/selector lookup happens in Stage 4.1.
    // A supported OS family is not enough: each private integration capability
    // stays false until on-device runtime evidence for that family is converted
    // into a dedicated adapter/hook group.
    self.capabilities.privateIntegrationState = version.isSupportedTargetOS
        ? @"REQUIRES_DEVICE_VERIFICATION"
        : @"UNSUPPORTED_OS_INERT";

    SDSLogInfo(SDSLogCategoryHook, @"Runtime inspect: %@", self.capabilities.targetSummary);
}

@end
