//
//  SZRefreshTrailer.m
//  SZRefresh
//
//  Created by kinarobin on 2020/5/3.
//  Copyright © 2020 小码哥. All rights reserved.
//

#import "SZRefreshTrailer.h"
#import "UIView+SZExtension.h"
#import "UIScrollView+SZRefresh.h"
#import "UIScrollView+SZExtension.h"

@interface SZRefreshTrailer()
@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastRightDelta;
@end

@implementation SZRefreshTrailer

#pragma mark - 构造方法
+ (instancetype)trailerWithRefreshingBlock:(SZRefreshComponentAction)refreshingBlock {
    SZRefreshTrailer *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

+ (instancetype)trailerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    SZRefreshTrailer *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == SZRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.sz_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetX = self.scrollView.sz_offsetX;
    // 尾部控件刚好出现的offsetX
    CGFloat happenOffsetX = [self happenOffsetX];
    // 如果是向右滚动到看不见右边控件，直接返回
    if (currentOffsetX <= happenOffsetX) return;
    
    CGFloat pullingPercent = (currentOffsetX - happenOffsetX) / self.sz_w;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == SZRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetX = happenOffsetX + self.sz_w;
        
        if (self.state == SZRefreshStateIdle && currentOffsetX > normal2pullingOffsetX) {
            self.state = SZRefreshStatePulling;
        } else if (self.state == SZRefreshStatePulling && currentOffsetX <= normal2pullingOffsetX) {
            // 转为普通状态
            self.state = SZRefreshStateIdle;
        }
    } else if (self.state == SZRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(SZRefreshState)state {
    SZRefreshCheckState
    // 根据状态来设置属性
    if (state == SZRefreshStateNoMoreData || state == SZRefreshStateIdle) {
        // 刷新完毕
        if (SZRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                if (self.endRefreshingAnimationBeginAction) {
                    self.endRefreshingAnimationBeginAction();
                }
                
                self.scrollView.sz_insetR -= self.lastRightDelta;
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }];
        }
        
        CGFloat deltaW = [self widthForContentBreakView];
        // 刚刷新完毕
        if (SZRefreshStateRefreshing == oldState && deltaW > 0 && self.scrollView.sz_totalDataCount != self.lastRefreshCount) {
            self.scrollView.sz_offsetX = self.scrollView.sz_offsetX;
        }
    } else if (state == SZRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.sz_totalDataCount;
        
        [UIView animateWithDuration:self.fastAnimationDuration animations:^{
            CGFloat right = self.sz_w + self.scrollViewOriginalInset.right;
            CGFloat deltaW = [self widthForContentBreakView];
            if (deltaW < 0) { // 如果内容宽度小于view的宽度
                right -= deltaW;
            }
            self.lastRightDelta = right - self.scrollView.sz_insetR;
            self.scrollView.sz_insetR = right;
            
            // 设置滚动位置
            CGPoint offset = self.scrollView.contentOffset;
            offset.x = [self happenOffsetX] + self.sz_w;
            [self.scrollView setContentOffset:offset animated:NO];
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的宽度
    CGFloat contentWidth = self.scrollView.sz_contentW + self.ignoredScrollViewContentInsetRight;
    // 表格的宽度
    CGFloat scrollWidth = self.scrollView.sz_w - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInsetRight;
    // 设置位置和尺寸
    self.sz_x = MAX(contentWidth, scrollWidth);
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.sz_h = _scrollView.sz_h;
    // 设置自己的宽度
    self.sz_w = SZRefreshTrailWidth;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        // 设置支持水平弹簧效果
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = NO;
    }
}

#pragma mark . 链式语法部分 .

- (instancetype)linkTo:(UIScrollView *)scrollView {
    scrollView.sz_trailer = self;
    return self;
}

#pragma mark - 刚好看到上拉刷新控件时的contentOffset.x
- (CGFloat)happenOffsetX {
    CGFloat deltaW = [self widthForContentBreakView];
    if (deltaW > 0) {
        return deltaW - self.scrollViewOriginalInset.left;
    } else {
        return - self.scrollViewOriginalInset.left;
    }
}

#pragma mark 获得scrollView的内容 超出 view 的宽度
- (CGFloat)widthForContentBreakView {
    CGFloat w = self.scrollView.frame.size.width - self.scrollViewOriginalInset.right - self.scrollViewOriginalInset.left;
    return self.scrollView.contentSize.width - w;
}

@end
