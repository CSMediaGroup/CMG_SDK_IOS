//
//  SZSideBar.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/4/18.
//

#import "SZSideBar.h"
#import "SZDefines.h"
#import "UIView+MJCategory.h"
#import "UIColor+MJCategory.h"
#import <Masonry/Masonry.h>
#import "MJButton.h"
#import "UIImage+MJCategory.h"
#import "SZGlobalInfo.h"
#import "SZInputView.h"
#import "SZCommentList.h"
#import "SZCommentDataModel.h"
#import "SZCommentModel.h"
#import "MJHUD.h"
#import "SZStatusModel.h"
#import "SZContentStateModel.h"
#import "IQDataBinding.h"
#import "SZData.h"
#import "SZContentModel.h"
#import "SZManager.h"
#import "UIResponder+MJCategory.h"


@interface SZSideBar ()
@property(strong,nonatomic)NSString * contentId;
@end

@implementation SZSideBar
{
    SZCommentList * commentListView;
    
    UILabel * commentCount;
    
    MJButton * zanBtn;
    MJButton * commentBtn;
    MJButton * shareBtn;
    
    UILabel * zanLabel;
    UILabel * shareLabel;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
        
        [self addObserver];
    }
    return self;
}


#pragma mark - 数据绑定
-(void)addObserver
{
    //绑定数据
    [self bindModel:[SZData sharedSZData]];
    
    __weak typeof (self) weakSelf = self;
    self.observe(@"currentContentId",^(id value){
        weakSelf.contentId = value;
    }).observe(@"contentStateUpdateTime",^(id value){
        [weakSelf updateContentStateData];
    }).observe(@"contentZanTime",^(id value){
        [weakSelf updateContentStateData];
    }).observe(@"contentCollectTime",^(id value){
        [weakSelf updateContentStateData];
    }).observe(@"contentCommentsUpdateTime",^(id value){
        [weakSelf updateCommentData];
    });
}







#pragma mark - 界面&布局
-(void)setupUI
{
    CGFloat spaceY = 33;
    CGFloat fontsize = 13;
    
    //点赞
    zanBtn = [[MJButton alloc]init];
    zanBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_sidebar_zan"];
    zanBtn.mj_imageObject_sel = [UIImage getBundleImage:@"sz_sidebar_zan_sel"];
    [zanBtn addTarget:self action:@selector(zanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zanBtn];
    [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(27);
    }];

    //点赞数
    zanLabel = [[UILabel alloc]init];
    zanLabel.text=@"点赞";
    zanLabel.font=FONT(fontsize);
    zanLabel.textColor=HW_WHITE;
    zanLabel.alpha=0.5;
    zanLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:zanLabel];
    [zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(zanBtn.mas_centerX);
        make.top.mas_equalTo(zanBtn.mas_bottom).offset(3);
    }];

    
    
    //评论按钮
    commentBtn = [[MJButton alloc]init];
    commentBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_sidebar_comment"];
    [commentBtn addTarget:self action:@selector(commentTapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zanBtn.mas_bottom).offset(spaceY);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(27);
    }];
    
    
    //收藏数
    commentCount = [[UILabel alloc]init];
    commentCount.text=@"评论";
    commentCount.font=FONT(fontsize);
    commentCount.textColor=HW_WHITE;
    commentCount.alpha=0.5;
    commentCount.textAlignment=NSTextAlignmentCenter;
    [self addSubview:commentCount];
    [commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(commentBtn.mas_centerX);
        make.top.mas_equalTo(commentBtn.mas_bottom).offset(3);
    }];
    
    

    //分享按钮
    shareBtn = [[MJButton alloc]init];
    shareBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_sidebar_share"];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentBtn.mas_bottom).offset(spaceY);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(27);
        
    }];

    //分享
    shareLabel = [[UILabel alloc]init];
    shareLabel.text=@"转发";
    shareLabel.font=FONT(fontsize);
    shareLabel.textColor=HW_WHITE;
    shareLabel.alpha=0.5;
    shareLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareBtn.mas_centerX);
        make.top.mas_equalTo(shareBtn.mas_bottom).offset(3);
    }];
    
    //评论列表
    commentListView = [[SZCommentList alloc]init];
    [commentListView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
}

#pragma mark - 数据绑定回调
-(void)updateContentStateData
{
    //取数据
    SZContentStateModel * stateM = [[SZData sharedSZData].contentStateDic valueForKey:self.contentId];
    
    zanBtn.MJSelectState = stateM.whetherLike;
    
    if (stateM.likeCountShow>0)
    {
        zanLabel.text = [NSString stringWithFormat:@"%ld",(long)stateM.likeCountShow];
    }
    else
    {
        zanLabel.text = @"点赞";
    }
}


-(void)updateCommentData
{
    SZCommentDataModel * commentM = [[SZData sharedSZData].contentCommentDic valueForKey:self.contentId];
    if (commentM.total==0)
    {
        commentCount.text = @"评论";
    }
    else
    {
        commentCount.text = [NSString stringWithFormat:@"%ld",commentM.total];
    }
}



#pragma mark - Btn Action
-(void)commentTapAction
{
    if (commentListView.superview==nil)
    {
        //listview
        [self.window addSubview:commentListView];
        
        [commentListView showCommentList:YES];
    }
}


-(void)zanBtnAction
{
    //未登录则跳转登录
    if (![SZGlobalInfo sharedManager].SZRMToken.length)
    {
        [SZGlobalInfo mjshowLoginAlert];
        return;
    }
    
    [[SZData sharedSZData]requestZan];
}




-(void)shareBtnAction
{
    [MJHUD_Selection showShareView:^(id objc) {
        NSNumber * number = objc;
        SZ_SHARE_PLATFORM plat = number.integerValue;
        SZContentModel * contentModel = [[SZData sharedSZData].contentDetailDic valueForKey:self.contentId];
        [SZGlobalInfo mjshareToPlatform:plat content:contentModel source:@"底部分享"];
    }];
}



@end
