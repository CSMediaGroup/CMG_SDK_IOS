//
//  SZRefreshAutoStateFooter.h
//  SZRefresh
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#if __has_include(<SZRefresh/SZRefreshAutoFooter.h>)
#import <SZRefresh/SZRefreshAutoFooter.h>
#else
#import "SZRefreshAutoFooter.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SZRefreshAutoStateFooter : SZRefreshAutoFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (instancetype)setTitle:(NSString *)title forState:(SZRefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end

NS_ASSUME_NONNULL_END
