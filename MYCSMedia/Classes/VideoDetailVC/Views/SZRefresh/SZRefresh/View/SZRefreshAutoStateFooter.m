//
//  SZRefreshAutoStateFooter.m
//  SZRefresh
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "SZRefreshAutoStateFooter.h"
#import "NSBundle+SZRefresh.h"

@interface SZRefreshAutoFooter (TapTriggerFix)

- (void)beginRefreshingWithoutValidation;
@end


@implementation SZRefreshAutoFooter (TapTriggerFix)

- (void)beginRefreshingWithoutValidation {
    [super beginRefreshing];
}

@end

@interface SZRefreshAutoStateFooter()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation SZRefreshAutoStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel sz_label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (instancetype)setTitle:(NSString *)title forState:(SZRefreshState)state
{
    if (title == nil) return self;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
    return self;
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == SZRefreshStateIdle) {
        [super beginRefreshingWithoutValidation];
    }
}

- (void)textConfiguration {
    // 初始化文字
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshAutoFooterIdleText] forState:SZRefreshStateIdle];
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshAutoFooterRefreshingText] forState:SZRefreshStateRefreshing];
    [self setTitle:[NSBundle sz_localizedStringForKey:SZRefreshAutoFooterNoMoreDataText] forState:SZRefreshStateNoMoreData];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = SZRefreshLabelLeftInset;
    
    [self textConfiguration];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)i18nDidChange {
    [self textConfiguration];
    
    [super i18nDidChange];
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(SZRefreshState)state
{
    SZRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == SZRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end
