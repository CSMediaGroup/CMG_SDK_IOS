//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIScrollView+SZRefresh.h
//  SZRefresh
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//  给ScrollView增加下拉刷新、上拉刷新、 左滑刷新的功能

#import <UIKit/UIKit.h>
#if __has_include(<SZRefresh/SZRefreshConst.h>)
#import <SZRefresh/SZRefreshConst.h>
#else
#import "SZRefreshConst.h"
#endif

@class SZRefreshHeader, SZRefreshFooter, SZRefreshTrailer;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SZRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic, nullable) SZRefreshHeader *sz_header;
@property (strong, nonatomic, nullable) SZRefreshHeader *header SZRefreshDeprecated("使用sz_header");
/** 上拉刷新控件 */
@property (strong, nonatomic, nullable) SZRefreshFooter *sz_footer;
@property (strong, nonatomic, nullable) SZRefreshFooter *footer SZRefreshDeprecated("使用sz_footer");

/** 左滑刷新控件 */
@property (strong, nonatomic, nullable) SZRefreshTrailer *sz_trailer;

#pragma mark - other
- (NSInteger)sz_totalDataCount;

@end

NS_ASSUME_NONNULL_END
