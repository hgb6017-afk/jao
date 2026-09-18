#import "SDSCallHistoryService.h"
#import "../Utilities/SDSLogger.h"
NSErrorDomain const SDSCallHistoryServiceErrorDomain = @"com.smartdialsim.callhistory";

@implementation SDSCallHistoryService
- (BOOL)available { return NO; }
- (NSString *)providerDescription { return @"REQUIRES_DEVICE_VERIFICATION"; }
- (void)loadRecentCallsWithCompletion:(void (^)(NSArray<SDSCallHistoryEntry *> *entries, NSError * _Nullable error))completion {
    if (!completion) return;
    NSError *error = [NSError errorWithDomain:SDSCallHistoryServiceErrorDomain
                                         code:100
                                     userInfo:@{NSLocalizedDescriptionKey:
                                         @"Call history provider is intentionally disabled until the actual Phone runtime service/API is verified separately on iOS 15.x and iOS 16.2."}];
    SDSLogInfo(SDSLogCategoryCallHistory, @"Call history unavailable: per-family runtime provider not verified");
    completion(@[], error);
}
- (void)startObservingChangesWithHandler:(dispatch_block_t)handler { (void)handler; }
- (void)stopObservingChanges {}
@end
