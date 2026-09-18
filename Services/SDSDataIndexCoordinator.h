#import <Foundation/Foundation.h>
@class SDSSearchIndex, SDSContactsService, SDSCallHistoryService;
NS_ASSUME_NONNULL_BEGIN
@interface SDSDataIndexCoordinator : NSObject
@property(atomic, strong, readonly) SDSSearchIndex *currentIndex;
- (instancetype)initWithContactsService:(SDSContactsService *)contactsService
                     callHistoryService:(SDSCallHistoryService *)callHistoryService;
- (void)refreshWithContactsEnabled:(BOOL)contactsEnabled
                callHistoryEnabled:(BOOL)callHistoryEnabled
                     defaultRegion:(nullable NSString *)region
                        completion:(nullable dispatch_block_t)completion;
- (void)startChangeObservation;
- (void)stopChangeObservation;
@end
NS_ASSUME_NONNULL_END
