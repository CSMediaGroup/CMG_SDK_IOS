//
//  SZRefreshBackStateFooter.h
//  SZRefresh
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#if __has_include(<SZRefresh/SZRefreshBackFooter.h>)
#import <SZRefresh/SZRefreshBackFooter.h>
#else
#import "SZRefreshBackFooter.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SZRefreshBackStateFooter : SZRefreshBackFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (instancetype)setTitle:(NSString *)title forState:(SZRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(SZRefreshState)state;
@end

NS_ASSUME_NONNULL_END
