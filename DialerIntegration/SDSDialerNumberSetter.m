#import "SDSDialerNumberSetter.h"
@implementation SDSDialerNumberSetter
- (BOOL)supported { return NO; }
- (BOOL)setCompleteNumberUsingVerifiedNativeFlow:(NSString *)number host:(id)host error:(NSError **)error {
    (void)number; (void)host;
    if (error) {
        *error = [NSError errorWithDomain:@"com.smartdialsim.dialer"
                                     code:100
                                 userInfo:@{NSLocalizedDescriptionKey:
                                     @"Native number setter requires per-family Phone runtime verification for iOS 15.x and iOS 16.2."}];
    }
    return NO;
}
@end
