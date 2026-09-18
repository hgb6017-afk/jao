#import "SDSSIMSelectorBridge.h"
@implementation SDSSIMSelectorBridge
- (BOOL)supported { return NO; }
- (NSString *)verificationState { return @"REQUIRES_DEVICE_VERIFICATION"; }
- (BOOL)attachToVerifiedNativeControl:(id)control { (void)control; return NO; }
- (void)applyPresentationOnly {}
- (void)restoreOriginalPresentation {}
- (void)detach {}
@end
