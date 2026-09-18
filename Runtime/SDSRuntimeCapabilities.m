#import "SDSRuntimeCapabilities.h"
@implementation SDSRuntimeCapabilities
- (instancetype)init {
    self = [super init];
    if (self) {
        _runtimeVersion = [SDSRuntimeVersion currentVersion];
        _targetSummary = @"REQUIRES_DEVICE_VERIFICATION";
        _privateIntegrationState = @"INERT";
    }
    return self;
}
@end
