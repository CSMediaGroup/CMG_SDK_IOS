//代码地址: https://github.com/CoderMJLee/SZRefresh
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

//弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

//日志输出
#ifdef DEBUG
#define SZRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define SZRefreshLog(...)
#endif

//过期提醒
#define SZRefreshDeprecated(DESCRIPTION) __attribute__((deprecated(DESCRIPTION)))

//运行时objc_msgSend
#define SZRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define SZRefreshMsgTarget(target) (__bridge void *)(target)

//RGB颜色
#define SZRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//文字颜色
#define SZRefreshLabelTextColor SZRefreshColor(90, 90, 90)

//字体大小
#define SZRefreshLabelFont [UIFont boldSystemFontOfSize:14]

//常量
UIKIT_EXTERN const CGFloat SZRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat SZRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat SZRefreshFooterHeight;
UIKIT_EXTERN const CGFloat SZRefreshTrailWidth;
UIKIT_EXTERN const CGFloat SZRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat SZRefreshSlowAnimationDuration;


UIKIT_EXTERN NSString *const SZRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const SZRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const SZRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const SZRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const SZRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const SZRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const SZRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const SZRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const SZRefreshTrailerIdleText;
UIKIT_EXTERN NSString *const SZRefreshTrailerPullingText;

UIKIT_EXTERN NSString *const SZRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const SZRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const SZRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const SZRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const SZRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const SZRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const SZRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const SZRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const SZRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const SZRefreshHeaderNoneLastDateText;

UIKIT_EXTERN NSString *const SZRefreshDidChangeLanguageNotification;

//状态检查
#define SZRefreshCheckState \
SZRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

//异步主线程执行，不强持有Self
#define SZRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});

/// 替换方法实现
/// @param _fromClass 源类
/// @param _originSelector 源类的 Selector
/// @param _toClass  目标类
/// @param _newSelector 目标类的 Selector
CG_INLINE BOOL SZRefreshExchangeImplementations(
                                                Class _fromClass, SEL _originSelector,
                                                Class _toClass, SEL _newSelector) {
    if (!_fromClass || !_toClass) {
        return NO;
    }
    
    Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
    if (!newMethod) {
        return NO;
    }
    
    BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector,
                                         method_getImplementation(newMethod),
                                         method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP emptyIMP = imp_implementationWithBlock(^(id selfObject) {});
        IMP oriMethodIMP = method_getImplementation(oriMethod) ?: emptyIMP;
        const char *oriMethodTypeEncoding = method_getTypeEncoding(oriMethod) ?: "v@:";
        class_replaceMethod(_toClass, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}
