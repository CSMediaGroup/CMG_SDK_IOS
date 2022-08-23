#ifdef LITEAV
#import "TXVodPlayer.h"
#import "TXLivePlayer.h"
#import "TXImageSprite.h"
#import "TXLiveBase.h"
#else
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#endif

#import "SZSuperPlayerView.h"
#import "SZSuperPlayerModel.h"
#import "SZSuperPlayerControlView.h"
#import "SZPlayerControlViewDelegate.h"
#import "SZSuperPlayerWindow.h"
#import "SZDefaultControlView.h"




// 屏幕的宽
#define SZScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define SZScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define COLOR_RGBA(r,g,b,a)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define GET_SZPlayerImage(file)              [UIImage imageNamed:[@"CSAssets.bundle/playerImages" stringByAppendingPathComponent:file]]

#define SZ_IsIPhoneX                           (SZScreenHeight >= 812 || SZScreenWidth >= 812)

#define SZPLAYER_TintColor COLOR_RGBA(252, 89, 81, 1)

#define LOG_ME NSLog(@"%s", __func__);
