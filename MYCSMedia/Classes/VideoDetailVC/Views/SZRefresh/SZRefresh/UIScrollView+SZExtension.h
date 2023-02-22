//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIScrollView+Extension.h
//  SZRefresh
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SZExtension)
@property (readonly, nonatomic) UIEdgeInsets sz_inset;

@property (assign, nonatomic) CGFloat sz_insetT;
@property (assign, nonatomic) CGFloat sz_insetB;
@property (assign, nonatomic) CGFloat sz_insetL;
@property (assign, nonatomic) CGFloat sz_insetR;

@property (assign, nonatomic) CGFloat sz_offsetX;
@property (assign, nonatomic) CGFloat sz_offsetY;

@property (assign, nonatomic) CGFloat sz_contentW;
@property (assign, nonatomic) CGFloat sz_contentH;
@end

NS_ASSUME_NONNULL_END
