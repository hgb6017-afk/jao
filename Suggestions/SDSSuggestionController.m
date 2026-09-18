#import "SDSSuggestionController.h"
#import "SDSSuggestionView.h"
#import "../Search/SDSSearchIndex.h"
#import "../Utilities/SDSDebouncer.h"
#import "../Utilities/SDSLogger.h"

@interface SDSSuggestionController ()
@property(nonatomic, copy) SDSSearchIndex *(^indexProvider)(void);
@property(nonatomic, strong, readwrite) SDSSuggestionView *suggestionView;
@property(nonatomic, strong) SDSDebouncer *debouncer;
@property(atomic) NSUInteger queryGeneration;
@property(nonatomic, strong) dispatch_queue_t searchQueue;
@property(nonatomic, copy) NSArray<NSLayoutConstraint *> *activeConstraints;
@end

@implementation SDSSuggestionController
- (instancetype)initWithSearchIndexProvider:(SDSSearchIndex *(^)(void))provider {
    self = [super init];
    if (self) {
        _indexProvider = [provider copy];
        _suggestionView = [[SDSSuggestionView alloc] initWithFrame:CGRectZero];
        _debouncer = [[SDSDebouncer alloc] initWithDelay:0.06 queue:dispatch_get_main_queue()];
        _searchQueue = dispatch_queue_create("com.smartdialsim.search", DISPATCH_QUEUE_SERIAL);
        __weak typeof(self) weakSelf = self;
        _suggestionView.selectionHandler = ^(id suggestion) { if (weakSelf.selectionHandler) weakSelf.selectionHandler(suggestion); };
    }
    return self;
}
- (void)attachToHostView:(UIView *)hostView topAnchor:(NSLayoutYAxisAnchor *)topAnchor bottomAnchor:(NSLayoutYAxisAnchor *)bottomAnchor {
    if (self.suggestionView.superview == hostView) return;
    [self detach];
    [hostView addSubview:self.suggestionView];
    self.activeConstraints = @[
        [self.suggestionView.leadingAnchor constraintEqualToAnchor:hostView.safeAreaLayoutGuide.leadingAnchor],
        [self.suggestionView.trailingAnchor constraintEqualToAnchor:hostView.safeAreaLayoutGuide.trailingAnchor],
        [self.suggestionView.topAnchor constraintEqualToAnchor:topAnchor constant:4],
        [self.suggestionView.bottomAnchor constraintEqualToAnchor:bottomAnchor constant:-4]
    ];
    [NSLayoutConstraint activateConstraints:self.activeConstraints];
}
- (void)updateDialString:(NSString *)dialString useT9:(BOOL)useT9 maxResults:(NSUInteger)maxResults {
    NSUInteger generation = ++self.queryGeneration;
    if (!dialString.length) { [self cancelPendingSearch]; [self.suggestionView hideSuggestions]; return; }
    __weak typeof(self) weakSelf = self;
    [self.debouncer schedule:^{
        dispatch_async(weakSelf.searchQueue, ^{
            SDSSearchIndex *index = weakSelf.indexProvider ? weakSelf.indexProvider() : nil;
            NSArray *results = [index search:dialString useT9:useT9 limit:maxResults defaultRegion:@"VN"] ?: @[];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf || generation != weakSelf.queryGeneration) return;
                [weakSelf.suggestionView showSuggestions:results];
                SDSLogInfo(SDSLogCategorySuggestions, @"Suggestion UI updated: %lu results", (unsigned long)results.count);
            });
        });
    }];
}
- (void)cancelPendingSearch { self.queryGeneration++; [self.debouncer cancel]; }
- (void)detach { [self cancelPendingSearch]; [self.suggestionView hideSuggestions]; if (self.activeConstraints) [NSLayoutConstraint deactivateConstraints:self.activeConstraints]; self.activeConstraints = nil; [self.suggestionView removeFromSuperview]; }
- (void)dealloc { [self detach]; }
@end
