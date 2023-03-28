//
//  SZRefreshBackGifFooter.h
//  SZRefresh
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#if __has_include(<SZRefresh/SZRefreshBackStateFooter.h>)
#import <SZRefresh/SZRefreshBackStateFooter.h>
#else
#import "SZRefreshBackStateFooter.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SZRefreshBackGifFooter : SZRefreshBackStateFooter
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (instancetype)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(SZRefreshState)state;
- (instancetype)setImages:(NSArray *)images forState:(SZRefreshState)state;
@end

NS_ASSUME_NONNULL_END
