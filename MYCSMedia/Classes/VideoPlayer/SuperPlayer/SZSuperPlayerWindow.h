//
//  SZSuperPlayerWindow.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZSuperPlayerView;

typedef void(^SZPlayerWindowEventHandler)(void);

/// 播放器小窗Window
@interface SZSuperPlayerWindow : UIWindow

/// 显示小窗
- (void)show;
/// 隐藏小窗
- (void)hide;
/// 单例
+ (instancetype)sharedInstance;

@property (nonatomic,copy) SZPlayerWindowEventHandler backHandler;
@property (nonatomic,copy) SZPlayerWindowEventHandler closeHandler;  // 默认关闭
/// 小窗播放器
@property (nonatomic,weak) SZSuperPlayerView *superPlayer;
/// 小窗主view
@property (readonly) UIView *rootView;
/// 点击小窗返回的controller
@property UIViewController *backController;
/// 小窗是否显示
@property (readonly) BOOL isShowing;  //

@end
