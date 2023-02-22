//
//  SZRefreshConfig.m
//
//  Created by Frank on 2018/11/27.
//  Copyright © 2018 小码哥. All rights reserved.
//

#import "SZRefreshConfig.h"
#import "SZRefreshConst.h"
#import "NSBundle+SZRefresh.h"

@interface SZRefreshConfig (Bundle)

+ (void)resetLanguageResourceCache;

@end

@implementation SZRefreshConfig

static SZRefreshConfig *sz_RefreshConfig = nil;

+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sz_RefreshConfig = [[self alloc] init];
    });
    return sz_RefreshConfig;
}

- (void)setLanguageCode:(NSString *)languageCode {
    if ([languageCode isEqualToString:_languageCode]) {
        return;
    }
    
    _languageCode = languageCode;
    // 重置语言资源
    [SZRefreshConfig resetLanguageResourceCache];
    [NSNotificationCenter.defaultCenter
     postNotificationName:SZRefreshDidChangeLanguageNotification object:self];
}

@end
