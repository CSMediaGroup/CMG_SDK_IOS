// 代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIView+Extension.h
//  SZRefresh
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SZExtension)
@property (assign, nonatomic) CGFloat sz_x;
@property (assign, nonatomic) CGFloat sz_y;
@property (assign, nonatomic) CGFloat sz_w;
@property (assign, nonatomic) CGFloat sz_h;
@property (assign, nonatomic) CGSize sz_size;
@property (assign, nonatomic) CGPoint sz_origin;
@end

NS_ASSUME_NONNULL_END
