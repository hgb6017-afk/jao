#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface SDSSIMSelectorBridge : NSObject
@property(nonatomic, readonly) BOOL supported;
@property(nonatomic, copy, readonly) NSString *verificationState;
- (BOOL)attachToVerifiedNativeControl:(id)control;
- (void)applyPresentationOnly;
- (void)restoreOriginalPresentation;
- (void)detach;
@end
NS_ASSUME_NONNULL_END
