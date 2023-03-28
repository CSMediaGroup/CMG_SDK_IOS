//
//  SZRefreshNormalTrailer.h
//  SZRefresh
//
//  Created by kinarobin on 2020/5/3.
//  Copyright © 2020 小码哥. All rights reserved.
//

#if __has_include(<SZRefresh/SZRefreshStateTrailer.h>)
#import <SZRefresh/SZRefreshStateTrailer.h>
#else
#import "SZRefreshStateTrailer.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SZRefreshNormalTrailer : SZRefreshStateTrailer

@property (weak, nonatomic, readonly) UIImageView *arrowView;

@end

NS_ASSUME_NONNULL_END
