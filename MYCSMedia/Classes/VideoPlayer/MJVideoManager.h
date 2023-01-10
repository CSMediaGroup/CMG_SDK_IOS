//
//  SJVideoPlayer.h
//  智慧长沙
//
//  Created by 马佳 on 2019/10/10.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZSuperPlayer.h"
#import "SZContentModel.h"


typedef NS_ENUM(NSUInteger, MJVideoControlStyle) {
    MJControlStyleNormal = 0,
    MJControlStyleDisalbeGesture,
};


@interface MJVideoManager : NSObject

+ (MJVideoManager *)sharedMediaManager;





#pragma mark - Video
+(void)playFullScreenVideoAt:(UIViewController*)controller URL:(NSString*)url;
+(void)playWindowVideoAtView:(UIView*)view url:(NSString*)videoURL SZContentModel:(SZContentModel*)model renderModel:(NSInteger)type;
+(void)pauseWindowVideo;
+(void)destroyVideoPlayer;
+(SZSuperPlayerView *)videoPlayer;



@end
