#import "SDSSIMLabelProvider.h"
#import "../Config/SDSConstants.h"
@implementation SDSSIMLabelProvider
+ (NSString *)sanitizedLabel:(NSString *)input fallback:(NSString *)fallback {
    NSString *s = [[input ?: @"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
    if (!s.length) s = fallback;
    if (s.length > SDSMaximumSIMLabelLength) s = [s substringToIndex:SDSMaximumSIMLabelLength];
    return s;
}
+ (NSString *)labelForLogicalIndex:(NSUInteger)index customSIM1:(NSString *)sim1 customSIM2:(NSString *)sim2 {
    if (index == 0) return [self sanitizedLabel:sim1 fallback:@"SIM 1"];
    if (index == 1) return [self sanitizedLabel:sim2 fallback:@"SIM 2"];
    return [NSString stringWithFormat:@"SIM %lu", (unsigned long)(index + 1)];
}
@end
