//
//  SJVideoPlayer.m
//  智慧长沙
//
//  Created by 马佳 on 2019/10/10.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//

#import "MJVideoManager.h"
#import "SZVideoFullScreen.h"
#import <SDWebImage/SDWebImage.h>
#import "SZContentTracker.h"
@interface MJVideoManager ()<SZSuperPlayerDelegate>

//腾讯
@property(strong,nonatomic)SZSuperPlayerView * MJVideoView;

@end

@implementation MJVideoManager

#pragma mark - Singleton
+ (MJVideoManager *)sharedMediaManager
{
    static MJVideoManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil)
        {
            manager = [[MJVideoManager alloc]init];
            manager.MJVideoView = [[SZSuperPlayerView alloc] init];
        }
        });
    return manager;
}




#pragma mark - 腾讯播放器
+(SZSuperPlayerView *)videoPlayer
{
    return [MJVideoManager sharedMediaManager].MJVideoView;
}

+(void)playFullScreenVideoAt:(UIViewController *)controller URL:(NSString *)url
{
    //全屏VC
    SZVideoFullScreen * fullvc = [[SZVideoFullScreen alloc]init];
    fullvc.videoURL = url;
    fullvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:fullvc animated:NO completion:nil];
}

+(void)playWindowVideoAtView:(UIView*)view url:(NSString*)videoURL SZContentModel:(SZContentModel*)model renderModel:(NSInteger)type
{
    //设置播放层
    MJVideoManager * manager = [MJVideoManager sharedMediaManager];
    manager.MJVideoView.fatherView = view;
    manager.MJVideoView.delegate = manager;
    manager.MJVideoView.disableInteraction = YES;
    manager.MJVideoView.controlView.hidden = YES;
    
    //发广播
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SZRMVideoWillPlay" object:nil];
    
    //如果是老url
    if ([videoURL isEqualToString:manager.MJVideoView.playerModel.videoURL] && manager.MJVideoView.isLoaded)
    {
        
        //如果是暂停
        if (manager.MJVideoView.playerState==SZPlayerState_StatePause)
        {
            [manager.MJVideoView resume];
        }
        
        
        //正在播放
        else if (manager.MJVideoView.playerState==SZPlayerState_StatePlaying)
        {
            [manager.MJVideoView resume];
        }
        
        //停止播放
        else if (manager.MJVideoView.playerState==SZPlayerState_StateStopped)
        {
            [MJVideoManager playNewVideo:videoURL SZContentModel:model renderMode:type];
        }
        
        
        //不是则播放
        else
        {
            [MJVideoManager playNewVideo:videoURL SZContentModel:model renderMode:type];
        }
    }
    
    
    //新url
    else
    {
        [MJVideoManager playNewVideo:videoURL SZContentModel:model renderMode:type];
    }
    
}




//播放新视频
+(void)playNewVideo:(NSString*)videourl SZContentModel:(SZContentModel*)SZContentModel renderMode:(NSInteger)renderMode
{
    MJVideoManager * manager = [MJVideoManager sharedMediaManager];
    
    //删除原播放器
    [manager.MJVideoView destroyCorePlayer];
    
    //归零初始配置
    manager.MJVideoView.playerConfig.loop = NO;
    manager.MJVideoView.playerConfig.mute=NO;
    manager.MJVideoView.playerConfig.playRate = 1.0 ;
    manager.MJVideoView.playerConfig.renderMode = renderMode;
    
    
    //content model
    manager.MJVideoView.externalModel = SZContentModel;
    
    //是否是自动播放（手动播放会埋点不同的事件）
    manager.MJVideoView.isManualPlay = SZContentModel.isManualPlay;
    
    //NewModel
    SZSuperPlayerModel * playerModel = [[SZSuperPlayerModel alloc] init];
    playerModel.videoURL = videourl;
    [manager.MJVideoView playWithModel:playerModel];
    
    //tracking
    [SZContentTracker trackContentEvent:@"cms_client_show" content:SZContentModel];
}



//暂停
+(void)pauseWindowVideo
{
    MJVideoManager * manager = [MJVideoManager sharedMediaManager];
    
    if (manager.MJVideoView.isLoaded)
    {
        [manager.MJVideoView pause];
    }
    else
    {
        [MJVideoManager destroyVideoPlayer];
    }
}


//销毁
+(void)destroyVideoPlayer
{
    MJVideoManager * manager = [MJVideoManager sharedMediaManager];
    manager.MJVideoView.fatherView = nil;
    [manager.MJVideoView destroyCorePlayer];
}




@end
