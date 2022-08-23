//
//  SZSuperPlayerView+Private.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/9.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#ifndef SuperPlayerView_Private_h
#define SuperPlayerView_Private_h
#import "SZSuperPlayer.h"

#import "SZPlayerControlViewDelegate.h"
#import "SZNetWatcher.h"
#import <MediaPlayer/MediaPlayer.h>

#import "Masonry/Masonry.h"
#import "AFNetworking/AFNetworking.h"


// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, SZPanDirection){
    SZ_PanDirectionHorizontalMoved, // 横向移动
    SZ_PanDirectionVerticalMoved    // 纵向移动
};

typedef NS_ENUM(NSInteger, SZButtonAction) {
    SZ_ActionNone,
    SZ_ActionRetry,
    SZ_ActionSwitch,
    SZ_ActionIgnore,
    SZ_ActionContinueReplay,
};



@interface SZSuperPlayerView () <UIGestureRecognizerDelegate,UIAlertViewDelegate,
TXVodPlayListener, TXLivePlayListener, SZPlayerControlViewDelegate, TXLiveBaseDelegate, AVAssetResourceLoaderDelegate>


/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
@property (nonatomic, assign) CGFloat                startVeloctyPoint;

/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) SZPanDirection           panDirection;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 快进快退、View*/
@property (nonatomic, strong) SZFastView    *fastView;

@property (nonatomic, setter=setDragging:) BOOL isDragging;
/// 中间的提示按钮
@property (nonatomic, strong) UIButton               *middleBlackBtn;
@property SZButtonAction                               middleBlackBtnAction;

/** 系统菊花 */
@property (nonatomic, strong) SZSpinner *spinner;

@property (nonatomic, strong) UIButton               *lockTipsBtn;

@property (nonatomic, strong) SZSuperPlayerModel       *playerModel;

@property (class, readonly) UISlider *volumeViewSlider;

@property MPVolumeView *volumeView;

// add for txvodplayer
@property BOOL  isLoaded;

@property (nonatomic) BOOL  isShiftPlayback;

@property CGFloat maxLiveProgressTime;    // 直播最大进度/总时间
@property CGFloat liveProgressTime;       // 直播播放器回调过来的时间
@property CGFloat liveProgressBase;       // 直播播放器超出时移的最大时间
#define SZ_MAX_SHIFT_TIME  (2*60*60)
/** 是否是直播流 */
@property BOOL isLive;

/** 腾讯点播播放器 */
@property (nonatomic, strong) TXVodPlayer                *vodPlayer;
/** 腾讯直播播放器 */
@property (nonatomic, strong) TXLivePlayer               *livePlayer;

@property NSDate *reportTime;

@property SZNetWatcher *SZNetWatcher;

@property (nonatomic) CGFloat videoRatio;

@end


// ---------------------------------------------------------------

@class SZ_AdaptiveStream;

@interface SZSuperPlayerModel()

//@property (nonatomic, strong) NSString *drmType;
@property NSMutableArray<SZ_AdaptiveStream *> *streams;

//- (BOOL)canSetDrmType:(NSString *)drmType;

@end

#endif /* SuperPlayerView_Private_h */
