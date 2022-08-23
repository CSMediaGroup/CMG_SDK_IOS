//
//  SZPlayerSlider.h
//  Slider
//
//  Created by annidyfeng on 2018/8/27.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZ_PlayerPoint : NSObject
@property GLfloat where;
@property UIControl  *holder;
@property NSString *content;
@property NSInteger timeOffset;
@end

@protocol SZ_PlayerSliderDelegate <NSObject>
- (void)onPlayerPointSelected:(SZ_PlayerPoint *)point;
@end

@interface SZPlayerSlider : UISlider

@property NSMutableArray<SZ_PlayerPoint *> *pointArray;
@property UIProgressView *progressView;
@property (weak) id<SZ_PlayerSliderDelegate> delegate;
@property (nonatomic) BOOL hiddenPoints;

- (SZ_PlayerPoint *)addPoint:(GLfloat)where;

@end
