#import "SDSDialerInputObserver.h"
@implementation SDSDialerInputObserver
- (BOOL)supported { return NO; }
- (BOOL)startForVerifiedHost:(id)host changeHandler:(void (^)(NSString *))handler { (void)host; (void)handler; return NO; }
- (void)stop {}
@end
