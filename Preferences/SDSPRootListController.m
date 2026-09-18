#import "SDSPRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString * const Domain = @"com.smartdialsim.preferences";
static NSString * const Notify = @"com.smartdialsim.preferences.changed";

@implementation SDSPRootListController
- (NSArray *)specifiers {
    if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    return _specifiers;
}
- (void)resetPreferences {
    NSArray *keys = @[@"enabled", @"smartDialEnabled", @"contactsEnabled", @"callHistoryEnabled", @"t9Enabled", @"maxSuggestions", @"compactSIMEnabled", @"sim1Name", @"sim2Name"];
    for (NSString *key in keys) CFPreferencesSetAppValue((__bridge CFStringRef)key, NULL, (__bridge CFStringRef)Domain);
    CFPreferencesAppSynchronize((__bridge CFStringRef)Domain);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)Notify, NULL, NULL, YES);
    [self reloadSpecifiers];
}
@end
