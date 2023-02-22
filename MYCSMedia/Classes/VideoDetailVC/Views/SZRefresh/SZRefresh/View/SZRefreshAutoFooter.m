//
//  SZRefreshAutoFooter.m
//  SZRefresh
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "SZRefreshAutoFooter.h"
#import "NSBundle+SZRefresh.h"
#import "UIView+SZExtension.h"
#import "UIScrollView+SZExtension.h"
#import "UIScrollView+SZRefresh.h"

@interface SZRefreshAutoFooter()
/** 一个新的拖拽 */
@property (nonatomic) BOOL triggerByDrag;
@property (nonatomic) NSInteger leftTriggerTimes;
@end

@implementation SZRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.sz_insetB += self.sz_h;
        }
        
        // 设置位置
        self.sz_y = _scrollView.sz_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.sz_insetB -= self.sz_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
    
    self.autoTriggerTimes = 1;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
    CGFloat contentHeight = size.height == 0 ? self.scrollView.sz_contentH : size.height;
    // 设置位置
    CGFloat y = contentHeight + self.ignoredScrollViewContentInsetBottom;
    if (self.sz_y != y) {
        self.sz_y = y;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != SZRefreshStateIdle || !self.automaticallyRefresh || self.sz_y == 0) return;
    
    if (_scrollView.sz_insetT + _scrollView.sz_contentH > _scrollView.sz_h) { // 内容超过一个屏幕
        // 这里的_scrollView.sz_contentH替换掉self.sz_y更为合理
        if (_scrollView.sz_offsetY >= _scrollView.sz_contentH - _scrollView.sz_h + self.sz_h * self.triggerAutomaticallyRefreshPercent + _scrollView.sz_insetB - self.sz_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            if (_scrollView.isDragging) {
                self.triggerByDrag = YES;
            }
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != SZRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    
    switch (panState) {
        // 手松开
        case UIGestureRecognizerStateEnded: {
            if (_scrollView.sz_insetT + _scrollView.sz_contentH <= _scrollView.sz_h) {  // 不够一个屏幕
                if (_scrollView.sz_offsetY >= - _scrollView.sz_insetT) { // 向上拽
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            } else { // 超出一个屏幕
                if (_scrollView.sz_offsetY >= _scrollView.sz_contentH + _scrollView.sz_insetB - _scrollView.sz_h) {
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateBegan: {
            [self resetTriggerTimes];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)unlimitedTrigger {
    return self.leftTriggerTimes == -1;
}

- (void)beginRefreshing
{
    if (self.triggerByDrag && self.leftTriggerTimes <= 0 && !self.unlimitedTrigger) {
        return;
    }
    
    [super beginRefreshing];
}

- (void)setState:(SZRefreshState)state
{
    SZRefreshCheckState
    
    if (state == SZRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == SZRefreshStateNoMoreData || state == SZRefreshStateIdle) {
        if (self.triggerByDrag) {
            if (!self.unlimitedTrigger) {
                self.leftTriggerTimes -= 1;
            }
            self.triggerByDrag = NO;
        }
        
        if (SZRefreshStateRefreshing == oldState) {
            if (self.scrollView.pagingEnabled) {
                CGPoint offset = self.scrollView.contentOffset;
                offset.y -= self.scrollView.sz_insetB;
                [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                    self.scrollView.contentOffset = offset;
                    
                    if (self.endRefreshingAnimationBeginAction) {
                        self.endRefreshingAnimationBeginAction();
                    }
                } completion:^(BOOL finished) {
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                }];
                return;
            }
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)resetTriggerTimes {
    self.leftTriggerTimes = self.autoTriggerTimes;
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = SZRefreshStateIdle;
        
        self.scrollView.sz_insetB -= self.sz_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.sz_insetB += self.sz_h;
        
        // 设置位置
        self.sz_y = _scrollView.sz_contentH;
    }
}

- (void)setAutoTriggerTimes:(NSInteger)autoTriggerTimes {
    _autoTriggerTimes = autoTriggerTimes;
    self.leftTriggerTimes = autoTriggerTimes;
}
@end
