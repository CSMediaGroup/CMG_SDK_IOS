//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIScrollView+Extension.m
//  SZRefresh
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+SZExtension.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation UIScrollView (SZExtension)

static BOOL respondsToAdjustedContentInset_;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        respondsToAdjustedContentInset_ = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}

- (UIEdgeInsets)sz_inset
{
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setSz_insetT:(CGFloat)sz_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = sz_insetT;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)sz_insetT
{
    return self.sz_inset.top;
}

- (void)setSz_insetB:(CGFloat)sz_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = sz_insetB;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)sz_insetB
{
    return self.sz_inset.bottom;
}

- (void)setSz_insetL:(CGFloat)sz_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = sz_insetL;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)sz_insetL
{
    return self.sz_inset.left;
}

- (void)setSz_insetR:(CGFloat)sz_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = sz_insetR;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)sz_insetR
{
    return self.sz_inset.right;
}

- (void)setSz_offsetX:(CGFloat)sz_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = sz_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)sz_offsetX
{
    return self.contentOffset.x;
}

- (void)setSz_offsetY:(CGFloat)sz_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = sz_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)sz_offsetY
{
    return self.contentOffset.y;
}

- (void)setSz_contentW:(CGFloat)sz_contentW
{
    CGSize size = self.contentSize;
    size.width = sz_contentW;
    self.contentSize = size;
}

- (CGFloat)sz_contentW
{
    return self.contentSize.width;
}

- (void)setSz_contentH:(CGFloat)sz_contentH
{
    CGSize size = self.contentSize;
    size.height = sz_contentH;
    self.contentSize = size;
}

- (CGFloat)sz_contentH
{
    return self.contentSize.height;
}
@end
#pragma clang diagnostic pop
