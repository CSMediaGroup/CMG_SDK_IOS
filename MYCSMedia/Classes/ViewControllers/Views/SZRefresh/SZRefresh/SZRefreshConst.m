//  代码地址: https://github.com/CoderMJLee/SZRefresh
#import <UIKit/UIKit.h>

const CGFloat SZRefreshLabelLeftInset = 25;
const CGFloat SZRefreshHeaderHeight = 54.0;
const CGFloat SZRefreshFooterHeight = 44.0;
const CGFloat SZRefreshTrailWidth = 60.0;
const CGFloat SZRefreshFastAnimationDuration = 0.25;
const CGFloat SZRefreshSlowAnimationDuration = 0.4;


NSString *const SZRefreshKeyPathContentOffset = @"contentOffset";
NSString *const SZRefreshKeyPathContentInset = @"contentInset";
NSString *const SZRefreshKeyPathContentSize = @"contentSize";
NSString *const SZRefreshKeyPathPanState = @"state";

NSString *const SZRefreshHeaderLastUpdatedTimeKey = @"SZRefreshHeaderLastUpdatedTimeKey";

NSString *const SZRefreshHeaderIdleText = @"SZRefreshHeaderIdleText";
NSString *const SZRefreshHeaderPullingText = @"SZRefreshHeaderPullingText";
NSString *const SZRefreshHeaderRefreshingText = @"SZRefreshHeaderRefreshingText";

NSString *const SZRefreshTrailerIdleText = @"SZRefreshTrailerIdleText";
NSString *const SZRefreshTrailerPullingText = @"SZRefreshTrailerPullingText";

NSString *const SZRefreshAutoFooterIdleText = @"SZRefreshAutoFooterIdleText";
NSString *const SZRefreshAutoFooterRefreshingText = @"SZRefreshAutoFooterRefreshingText";
NSString *const SZRefreshAutoFooterNoMoreDataText = @"SZRefreshAutoFooterNoMoreDataText";

NSString *const SZRefreshBackFooterIdleText = @"SZRefreshBackFooterIdleText";
NSString *const SZRefreshBackFooterPullingText = @"SZRefreshBackFooterPullingText";
NSString *const SZRefreshBackFooterRefreshingText = @"SZRefreshBackFooterRefreshingText";
NSString *const SZRefreshBackFooterNoMoreDataText = @"SZRefreshBackFooterNoMoreDataText";

NSString *const SZRefreshHeaderLastTimeText = @"SZRefreshHeaderLastTimeText";
NSString *const SZRefreshHeaderDateTodayText = @"SZRefreshHeaderDateTodayText";
NSString *const SZRefreshHeaderNoneLastDateText = @"SZRefreshHeaderNoneLastDateText";

NSString *const SZRefreshDidChangeLanguageNotification = @"SZRefreshDidChangeLanguageNotification";
