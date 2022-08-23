#import <UIKit/UIKit.h>
#import "SZSuperPlayer.h"
#import "SZSuperPlayerModel.h"
#import "SZSuperPlayerViewConfig.h"
#import "SZVideoErrorMessageView.h"
#import "ContentModel.h"

@class SZSuperPlayerControlView;
@class SZSuperPlayerView;


@protocol SZSuperPlayerDelegate <NSObject>
@optional
//返回事件
- (void)superPlayerDidClickBackAction:(SZSuperPlayerView *)player;
//全屏改变通知
- (void)superPlayerDidChangeFullScreenState:(SZSuperPlayerView *)player;
//播放开始通知
- (void)superPlayerDidStartPlay:(SZSuperPlayerView *)player;
//播放结束通知
- (void)superPlayerDidFinishPlay:(SZSuperPlayerView *)player;
//播放错误通知
- (void)superPlayerError:(SZSuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why;
@end



// 播放器的状态
typedef NS_ENUM(NSInteger, SZPlayerState) {
    SZPlayerState_StateFailed,     // 播放失败  0
    SZPlayerState_StateBuffering,  // 缓冲中    1
    SZPlayerState_StatePlaying,    // 播放中    2
    SZPlayerState_StateStopped,    // 停止播放  3
    SZPlayerState_StatePause,      // 暂停播放  4
    SZPlayerState_StateIntoBackground, //进入后台 5
    SZPlayerState_StateLoading,        //初次加载 6
    SZPlayerState_StatePrepareReplay  //准备重播 7
};




@interface SZSuperPlayerView : UIView

//UI
@property (nonatomic, weak) id<SZSuperPlayerDelegate> delegate;
@property (nonatomic, weak) UIView *fatherView;
@property (nonatomic,strong) SZSuperPlayerControlView *controlView;
@property (nonatomic,strong) UIImageView *coverImageView;
@property(strong,nonatomic)UIView *fullScreenBlackView;;
@property (nonatomic, strong) UIButton *repeatBtn;
@property(strong,nonatomic)UIView * sharingView;
@property(strong,nonatomic)SZVideoErrorMessageView * MJErrorMsgView;
@property(strong,nonatomic)UIView * MJStatusView;
@property(strong,nonatomic)UIImageView * middlePlayBtn;

//状态
@property (nonatomic, assign) SZPlayerState playerState;          //播放状态
@property (readonly) BOOL isLive;                                      //是否是直播流
@property (readonly)  BOOL isDragging;                                //是否在手势中
@property (readonly)  BOOL  isLoaded;                                 //是否加载成功
@property BOOL autoPlay;                                               //是否自动播放（在playWithModel前设置)
@property (nonatomic) CGFloat playDuration;                          //视频总时长
@property (nonatomic) CGFloat playCurrentTime;                       //视频当前播放时间
@property CGFloat startTime;                                          //起始播放时间(必须要在内核方法startplay前设置)
@property (readonly) SZSuperPlayerModel *playerModel;                 //播放的视频Model
@property SZSuperPlayerViewConfig *playerConfig;                      //播放器配置
@property TXImageSprite *imageSprite;                                //视频雪碧图
@property NSArray *keyFrameDescList;                                 //关键帧信息
@property(assign,nonatomic)BOOL ignoreWWAN;                         //允许4g播放
@property(assign,nonatomic)BOOL disableInteraction;                //禁止非全屏下的手势交互
@property(strong,nonatomic)ContentModel * externalModel;            //内容模型
@property(assign,nonatomic)BOOL isReplay;                            //是否是重播
@property(assign,nonatomic)BOOL isManualPlay;                       //是否是手动播放

//操作API
- (void)playWithModel:(SZSuperPlayerModel *)playerModel;
- (void)destroyCorePlayer;
- (void)resume;
- (void)pause;              //isLoaded == NO 时暂停无效
- (void)seekToTime:(NSInteger)dragedSeconds;            //从xx秒开始


//补充
-(void)switchToFullScreenMode:(BOOL)fullScreen;


@end
