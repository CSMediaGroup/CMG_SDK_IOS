//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIView+Extension.m
//  SZRefresh
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+SZExtension.h"

@implementation UIView (SZExtension)
- (void)setSz_x:(CGFloat)sz_x
{
    CGRect frame = self.frame;
    frame.origin.x = sz_x;
    self.frame = frame;
}

- (CGFloat)sz_x
{
    return self.frame.origin.x;
}

- (void)setSz_y:(CGFloat)sz_y
{
    CGRect frame = self.frame;
    frame.origin.y = sz_y;
    self.frame = frame;
}

- (CGFloat)sz_y
{
    return self.frame.origin.y;
}

- (void)setSz_w:(CGFloat)sz_w
{
    CGRect frame = self.frame;
    frame.size.width = sz_w;
    self.frame = frame;
}

- (CGFloat)sz_w
{
    return self.frame.size.width;
}

- (void)setSz_h:(CGFloat)sz_h
{
    CGRect frame = self.frame;
    frame.size.height = sz_h;
    self.frame = frame;
}

- (CGFloat)sz_h
{
    return self.frame.size.height;
}

- (void)setSz_size:(CGSize)sz_size
{
    CGRect frame = self.frame;
    frame.size = sz_size;
    self.frame = frame;
}

- (CGSize)sz_size
{
    return self.frame.size;
}

- (void)setSz_origin:(CGPoint)sz_origin
{
    CGRect frame = self.frame;
    frame.origin = sz_origin;
    self.frame = frame;
}

- (CGPoint)sz_origin
{
    return self.frame.origin;
}
@end
