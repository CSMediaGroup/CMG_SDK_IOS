//
//  SuperPlayerMoreView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZSuperPlayerViewConfig.h"

#define SZ_MoreViewWidth 330

@class SZSuperPlayerControlView;

@interface SZMoreContentView : UIView

@property (weak) SZSuperPlayerControlView *controlView;


@property UISlider *soundSlider;

@property UISlider *lightSlider;

@property (nonatomic) BOOL isLive;

@property SZSuperPlayerViewConfig *playerConfig;
- (void)update;

@end
