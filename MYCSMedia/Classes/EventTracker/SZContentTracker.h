//
//  SZContentTracker.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/31.
//

#import <Foundation/Foundation.h>
#import "SZContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZContentTracker : NSObject

+(void)trackContentEvent:(NSString*)eventName content:(SZContentModel*)contentM;

+(void)trackingVideoPlayingDuration:(SZContentModel*)content isPlaying:(BOOL)isplay currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;

+(void)trackingVideoPlayingDuration_manual:(SZContentModel*)content isPlaying:(BOOL)isplay currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;


//记录进度
+(void)recordPlayingProgress:(CGFloat)progess content:(SZContentModel*)contentM;

@end

NS_ASSUME_NONNULL_END
