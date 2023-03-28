//
//  SZCommentBar.m
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/29.
//

#import "SZCommentBar.h"
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

@interface SZCommentBar ()
@property(strong,nonatomic)NSString * contentId;
@end

@implementation SZCommentBar
{
    UIView * bgview;
    
    SZCommentList * commentListView;
    
    MJButton * sendBtn;
    UIView * sendBtnBG;
    
    MJButton * chatBtn;
    MJButton * zanBtn;
    MJButton * shareBtn;
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
    
    //监听 点赞数 评论数 点赞状态 评论列表数据
    __weak typeof (self) weakSelf = self;
    self.observe(@"currentContentId",^(id value){
        weakSelf.contentId = value;
        [weakSelf updateContentInfo];
    }).observe(@"contentStateUpdateTime",^(id value){
        [weakSelf updateContentStateData];
    }).observe(@"contentZanTime",^(id value){
        [weakSelf updateContentStateData];
    }).observe(@"contentCommentsUpdateTime",^(id value){
        [weakSelf updateCommentData];
    });
}



#pragma mark - Public
-(void)setCommentBarStyle:(NSInteger)style type:(NSInteger)type
{
    if (style==0)
    {
        bgview.backgroundColor=[UIColor whiteColor];
        
        sendBtnBG.backgroundColor=[UIColor blackColor];
        sendBtnBG.alpha = 0.05;
    }
    else
    {
        bgview.backgroundColor=[UIColor blackColor];
        bgview.alpha = 0.8;
        
        sendBtnBG.backgroundColor=HW_GRAY_BG_3;
        sendBtnBG.alpha = 1;
    }
}


#pragma mark - 界面&布局
-(void)setupUI
{
    self.backgroundColor=[UIColor whiteColor];
    
    //背景色
    bgview = [[UIView alloc]init];
    bgview.backgroundColor=[UIColor blackColor];
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //commentbar frame
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT-COMMENT_BAR_HEIGHT, SCREEN_WIDTH, COMMENT_BAR_HEIGHT)];
    
    //cornerRadius
    [self MJSetPartRadius:8 RoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    //发送按钮
    sendBtn = [[MJButton alloc]init];
    [sendBtn setImage:[UIImage getBundleImage:@"sz_commentbar_write"] forState:UIControlStateNormal];
    sendBtn.imageFrame=CGRectMake(14, 9, 12, 13.5);
    sendBtn.titleFrame=CGRectMake(34, 8, 155, 15);
    sendBtn.mj_text=@"写评论...";
    sendBtn.mj_font=FONT(14);
    sendBtn.mj_textColor=HW_BLACK;
    sendBtn.backgroundColor=HW_CLEAR;
    sendBtn.layer.cornerRadius=16;
    sendBtn.layer.borderWidth=MINIMUM_PX;
    sendBtn.layer.borderColor=HW_GRAY_BG_9.CGColor;
    [sendBtn addTarget:self action:@selector(sendCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(self).offset(-168);
    }];
    
    //发送按钮BG
    sendBtnBG = [[UIView alloc]init];
    sendBtnBG.layer.cornerRadius = sendBtn.layer.cornerRadius;
    sendBtnBG.layer.borderWidth=1;
    [self insertSubview:sendBtnBG belowSubview:sendBtn];
    [sendBtnBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.height.mas_equalTo(sendBtn);
    }];
    
    //查看评论按钮
    chatBtn = [[MJButton alloc]init];
    chatBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_commentbar_chat"];
    [chatBtn addTarget:self action:@selector(commentTapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sendBtn.mas_right).offset(14);
        make.centerY.mas_equalTo(sendBtn.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    
    
    //点赞
    zanBtn = [[MJButton alloc]init];
    zanBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_commentbar_zan"];
    zanBtn.mj_imageObject_sel = [UIImage getBundleImage:@"sz_commentbar_zan_sel"];
    [zanBtn addTarget:self action:@selector(zanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zanBtn];
    [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chatBtn.mas_right).offset(3);
        make.centerY.mas_equalTo(sendBtn.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    //分享按钮
    shareBtn = [[MJButton alloc]init];
    shareBtn.mj_imageObjec = [UIImage getBundleImage:@"sz_commentbar_share"];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zanBtn.mas_right).offset(3);
        make.centerY.mas_equalTo(sendBtn.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    //分割线
    UIView * sepaLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MINIMUM_PX)];
    sepaLine.backgroundColor=HW_GRAY_BORDER_2;
    [self addSubview:sepaLine];
    
    
    //评论列表
    commentListView = [[SZCommentList alloc]init];
    [commentListView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
}






#pragma mark - 数据绑定回调
//更新点赞状态
-(void)updateContentStateData
{
    //取数据
    SZContentStateModel * stateM = [[SZData sharedSZData].contentStateDic valueForKey:self.contentId];
    
    zanBtn.MJSelectState = stateM.whetherLike;
    
    
//    if (stateM.likeCountShow>0)
//    {
//
//        [zanBtn setBadgeCount:stateM.likeCountShow];
//    }
//    else
//    {
//        [zanBtn setBadgeCount:0];
//    }
    
    
    [zanBtn setBadgeNum:[NSString stringWithFormat:@"%ld",(long)stateM.likeCountShow] style:2];
}

//更新评论数
-(void)updateCommentData
{
    SZCommentDataModel * commentM = [[SZData sharedSZData].contentCommentDic valueForKey:self.contentId];
    if (commentM.total)
    {
        [chatBtn setBadgeStr:[NSString stringWithFormat:@"%ld",(long)commentM.total]];
    }
    else
    {
        [chatBtn setBadgeStr:@""];
    }
}

//更新是否禁止评论
-(void)updateContentInfo
{
    //判断是否禁止评论
    SZContentModel * contenM = [[SZData sharedSZData].contentDetailDic valueForKey:self.contentId];
    if(contenM.disableComment.boolValue)
    {
        sendBtn.mj_text=@"当前评论功能已关闭";
        sendBtn.userInteractionEnabled=NO;
    }
    else
    {
        sendBtn.mj_text=@"写评论...";
        sendBtn.userInteractionEnabled=YES;
    }
}





#pragma mark - Btn Action
-(void)commentTapAction
{
    if (commentListView.superview==nil)
    {
        //listview
        [self.superview addSubview:commentListView];
        
        [commentListView showCommentList:YES];
    }
}


-(void)sendCommentAction
{
    NSString * currentId = [SZData sharedSZData].currentContentId;
    
    __weak typeof (self) weakSelf = self;
    [SZInputView callInputView:TypeSendComment contentId:currentId replyId:nil placeHolder:@"发表您的评论" completion:^(id responseObject) {
        [MJHUD_Notice showSuccessView:@"评论已提交，请等待审核通过！" inView:weakSelf.window hideAfterDelay:2];
        
        [weakSelf commentTapAction];
    }];
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
        SZContentModel * SZContentModel = [[SZData sharedSZData].contentDetailDic valueForKey:self.contentId];
        [SZGlobalInfo mjshareToPlatform:plat content:SZContentModel source:@"底部分享"];
    }];
    
}






@end
