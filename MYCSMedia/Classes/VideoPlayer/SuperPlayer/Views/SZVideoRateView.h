//
//  SZVideoRateView.h
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/26.
//

#import <UIKit/UIKit.h>
#import "SZSuperPlayerViewConfig.h"
#import "SZSuperPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZVideoRateView : UIView
@property SZSuperPlayerViewConfig *playerConfig;
@property (weak) SZSuperPlayerControlView *controlView;
-(void)updateState;

@end

NS_ASSUME_NONNULL_END
