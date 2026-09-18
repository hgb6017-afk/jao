#import <Foundation/Foundation.h>
#import "Config/SDSPreferences.h"
#import "Runtime/SDSRuntimeInspector.h"
#import "Runtime/SDSRuntimeCapabilities.h"
#import "Runtime/SDSRuntimeVersion.h"
#import "Utilities/SDSLogger.h"

static SDSPreferences *gPreferences = nil;
static SDSRuntimeInspector *gRuntimeInspector = nil;

%ctor {
    @autoreleasepool {
        gPreferences = [SDSPreferences sharedPreferences];
        [gPreferences startObserving];

        if (!gPreferences.snapshot.enabled) {
            SDSLogInfo(SDSLogCategoryLifecycle, @"Tweak disabled by preferences");
            return;
        }

        gRuntimeInspector = [[SDSRuntimeInspector alloc] init];
        [gRuntimeInspector inspect];

        SDSRuntimeVersion *version = gRuntimeInspector.capabilities.runtimeVersion;
        if (!version.isSupportedTargetOS) {
            SDSLogInfo(SDSLogCategoryLifecycle,
                       @"Stage 4.1 inert: unsupported OS family; target scope is iOS 15.x and iOS 16.2");
            return;
        }

        SDSLogInfo(SDSLogCategoryLifecycle,
                   @"Stage 4.1 core loaded for %@; private Phone integration remains REQUIRES_DEVICE_VERIFICATION",
                   version.familyName);

        // Intentionally no Logos private hooks yet.
        // Future verified implementation will use separate groups/adapters:
        //   iOS 15.x  -> dedicated iOS15 hooks verified on an iOS 15 device
        //   iOS 16.2  -> dedicated iOS162 hooks verified on an iOS 16.2 device
        // Never initialize one family's private hooks on the other family.
    }
}
