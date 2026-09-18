#import "SDSDialerBridge.h"
@implementation SDSDialerBridge
- (BOOL)supported { return NO; }
- (NSString *)verificationState { return @"REQUIRES_DEVICE_VERIFICATION"; }
- (NSString *)currentDialString { return nil; }
- (BOOL)attachToVerifiedHostObject:(id)hostObject { (void)hostObject; return NO; }
- (void)detach {}
@end
