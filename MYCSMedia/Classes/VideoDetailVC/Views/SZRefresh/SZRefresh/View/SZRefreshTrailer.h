//
//  SZRefreshTrailer.h
//  SZRefresh
//
//  Created by kinarobin on 2020/5/3.
//  Copyright © 2020 小码哥. All rights reserved.
//

#if __has_include(<SZRefresh/SZRefreshComponent.h>)
#import <SZRefresh/SZRefreshComponent.h>
#else
#import "SZRefreshComponent.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SZRefreshTrailer : SZRefreshComponent

/** 创建trailer*/
+ (instancetype)trailerWithRefreshingBlock:(SZRefreshComponentAction)refreshingBlock;
/** 创建trailer */
+ (instancetype)trailerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 忽略多少scrollView的contentInset的right */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetRight;


@end

NS_ASSUME_NONNULL_END
