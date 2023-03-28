//
//  NSBundle+SZRefresh.h
//  SZRefresh
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (SZRefresh)
+ (instancetype)sz_refreshBundle;
+ (UIImage *)sz_arrowImage;
+ (UIImage *)sz_trailArrowImage;
+ (NSString *)sz_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)sz_localizedStringForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
