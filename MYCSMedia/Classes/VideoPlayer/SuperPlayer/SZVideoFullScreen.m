//
//  ZQVideoFullScreen.m
//  ZQVideoPlayer
//
//  Created by wang on 2018/10/20.
//  Copyright © 2018 wang. All rights reserved.
//

#import "SZVideoFullScreen.h"
#import "SZSuperPlayer.h"
#import "MJVideoManager.h"
@interface SZVideoFullScreen ()<SZSuperPlayerDelegate>
@end

@implementation SZVideoFullScreen

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor= [UIColor blackColor];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SZSuperPlayerView * playview = [MJVideoManager videoPlayer];
    
    
    //重置状态
    [playview destroyCorePlayer];
    
    //play
    SZSuperPlayerModel * playerModel = [[SZSuperPlayerModel alloc] init];
    playerModel.videoURL = self.videoURL;
    
    playview.coverImageView.backgroundColor=[UIColor blackColor];
    playview.playerConfig.loop = NO;
    playview.playerConfig.mute=NO;
    playview.playerConfig.playRate=1.0;
    [playview playWithModel:playerModel];
    
    //全屏
    playview.controlView.fullScreenState=YES;
    playview.controlView.onlyFullscreenMode=YES;
    playview.delegate=self;
    
    [playview switchToFullScreenMode:YES];
}



#pragma mark - Delegate
- (void)superPlayerDidClickBackAction:(SZSuperPlayerView *)player
{
    SZSuperPlayerView * playview = [MJVideoManager videoPlayer];
    [player setFatherView:nil];
    playview.controlView.fullScreenState=NO;
    playview.controlView.onlyFullscreenMode=NO;
    [playview switchToFullScreenMode:NO];
    
    [player pause];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
