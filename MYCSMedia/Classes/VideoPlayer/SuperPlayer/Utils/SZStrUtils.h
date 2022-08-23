//
//  SZStrUtils.h
//  Pods
//
//  Created by annidyfeng on 2018/9/28.
//

#import <Foundation/Foundation.h>

@interface SZStrUtils : NSObject

+ (NSString *)timeFormat:(NSInteger)totalTime;

@end

extern NSString * SZ_LoadFaildRetry;
extern NSString * SZ_BadNetRetry;
extern NSString * SZ_TimeShiftFailed;
extern NSString * SZ_HDSwitchFailed;
extern NSString * SZ_WeakNet;
