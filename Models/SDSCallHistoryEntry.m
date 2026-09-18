#import "SDSCallHistoryEntry.h"
@implementation SDSCallHistoryEntry
- (instancetype)initWithNumber:(NSString *)number date:(NSDate *)date count:(NSUInteger)count kind:(NSString *)kind {
    self = [super init];
    if (self) { _phoneNumber = [number copy] ?: @""; _lastInteractionDate = date; _interactionCount = count; _callKind = [kind copy]; }
    return self;
}
@end
