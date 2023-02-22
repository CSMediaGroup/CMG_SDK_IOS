//
//  SZRefreshStateTrailer.m
//  SZRefresh
//
//  Created by kinarobin on 2020/5/3.
//  Copyright © 2020 小码哥. All rights reserved.
//

#import "SZRefreshStateTrailer.h"
#import "NSBundle+SZRefresh.h"
#import "UIView+SZExtension.h"

@interface SZRefreshStateTrailer() {
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation SZRefreshStateTrailer
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles {
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        UILabel *stateLabel = [UILabel sz_label];
        stateLabel.numberOfLines = 0;
        [self addSubview:_stateLabel = stateLabel];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (instancetype)setTitle:(NSString *)title forState:(SZRefreshState)state {
    if (title == nil) return self;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
    return self;
}

- (void)textConfiguration {
    // 初始化文字
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshTrailerIdleText] forState:SZRefreshStateIdle];
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshTrailerPullingText] forState:SZRefreshStatePulling];
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshTrailerPullingText] forState:SZRefreshStateRefreshing];
}

#pragma mark - 覆盖父类的方法
- (void)prepare {
    [super prepare];
    
    [self textConfiguration];
}

- (void)i18nDidChange {
    [self textConfiguration];
    
    [super i18nDidChange];
}

- (void)setState:(SZRefreshState)state {
    SZRefreshCheckState
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    CGFloat stateLabelW = ceil(self.stateLabel.font.pointSize);
    // 状态
    if (noConstrainsOnStatusLabel) {
        self.stateLabel.center = CGPointMake(self.sz_w * 0.5, self.sz_h * 0.5);
        self.stateLabel.sz_size = CGSizeMake(stateLabelW, self.sz_h) ;
    }
}

@end
