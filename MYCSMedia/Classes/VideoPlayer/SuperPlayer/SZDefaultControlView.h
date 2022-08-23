//
//  SZDefaultControlView.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/30.
//

#import "SZSuperPlayerControlView.h"
#import "SZVideoRateView.h"
#import "MJButton.h"
#import "MJProgressView.h"
@interface SZDefaultControlView : SZSuperPlayerControlView


/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 弹幕按钮 */
@property (nonatomic, strong) UIButton                *danmakuBtn;
/** 截图按钮 */
@property (nonatomic, strong) UIButton                *captureBtn;
/** 更多按钮 */
@property (nonatomic, strong) UIButton                *moreBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *MJRateBtn;
/** 分辨率的View */
@property (nonatomic, strong) SZVideoRateView           *speedRateView;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *middleBtn;
/** 更多设置View */
@property (nonatomic, strong) SZMoreContentView        *moreContentView;
/** 返回直播 */
@property (nonatomic, strong) UIButton                *backLiveBtn;

//点赞按钮
@property(strong,nonatomic)MJButton * zanBtn;

//收藏按钮
@property(strong,nonatomic)MJButton * collectBtn;

//分享按钮
@property(strong,nonatomic)MJButton * shareBtn;

//外部拖动条
@property(strong,nonatomic)MJProgressView * externalSlider;

//外部全屏按钮
@property(strong,nonatomic)UIImageView * externalFullScreenBtn;


/// 画面比例
@property CGFloat videoRatio;

/** 滑杆 */
@property (nonatomic, strong) SZPlayerSlider   *videoSlider;

/** 重播按钮 */
@property (nonatomic, strong) UIButton       *repeatBtn;

/** 打点按钮 */
@property (nonatomic, strong) UIButton       *pointJumpBtn;


@property(strong,nonatomic)NSString * contentId;

//网络状态



@property BOOL isLive;





@end
