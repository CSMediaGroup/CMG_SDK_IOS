//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  SZRefreshFooter.m
//  SZRefresh
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "SZRefreshFooter.h"
#import "UIScrollView+SZRefresh.h"
#import "UIView+SZExtension.h"

@interface SZRefreshFooter()

@end

@implementation SZRefreshFooter
#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(SZRefreshComponentAction)refreshingBlock
{
    SZRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    SZRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.sz_h = SZRefreshFooterHeight;
    
    // 默认不会自动隐藏
//    self.automaticallyHidden = NO;
}

#pragma mark . 链式语法部分 .

- (instancetype)linkTo:(UIScrollView *)scrollView {
    scrollView.sz_footer = self;
    return self;
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    SZRefreshDispatchAsyncOnMainQueue(self.state = SZRefreshStateNoMoreData;)
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    SZRefreshDispatchAsyncOnMainQueue(self.state = SZRefreshStateIdle;)
}

- (void)setAutomaticallyHidden:(BOOL)automaticallyHidden
{
    _automaticallyHidden = automaticallyHidden;
}
@end
