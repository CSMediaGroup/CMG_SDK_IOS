//
//  SZWebVC.m
//  智慧长沙
//
//  Created by 马佳 on 2019/10/21.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//

#import "SZWebVC.h"
#import "MJWebView.h"
#import "SZDefines.h"
#import "UIColor+MJCategory.h"
#import "MJButton.h"
#import "UIImage+MJCategory.h"
#import "SZGlobalInfo.h"
#import "MJHUD.h"
#import "SZCommentBar.h"
#import "SZData.h"


@interface SZWebVC ()<MJWebviewDelegate>
{
    MJButton * shareBtn;
}
@end

@implementation SZWebVC
{
    UILabel * titleLabel;
    BOOL H5KeyboardShow;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setupLayout];
    
    [self addObservings];
    
    [_webview startLoadURL];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden=YES;

    //检查登录
    __weak typeof (self) weakSelf = self;
    [SZGlobalInfo checkLoginStatus:^(BOOL suc) {
        [weakSelf updateCurrentContentId];
    }];

    //检查分享按钮
    if (self.shareUrl.length&&self.shareTitle.length&&self.shareImg.length&&self.shareBrief.length)
    {
        shareBtn.hidden=NO;
    }
    else
    {
        shareBtn.hidden=YES;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden=NO;
}

-(void)dealloc
{
    [self removeObservings];
    MJLOG(@"SZWebVC_dealloc");
}



#pragma mark - Observe
-(void)addObservings
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillShow)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillHide)
                                          name:UIKeyboardWillHideNotification
                                          object:nil];
}
-(void)removeObservings
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)keyboardWillShow
{
    H5KeyboardShow = YES;
}

-(void)keyboardWillHide
{
    H5KeyboardShow = NO;
}



#pragma mark - 界面
-(void)setupLayout
{
    //BG
    self.view.backgroundColor=HW_WHITE;

    //禁止侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;

    //Webview
    _webview = [[MJWebview alloc]init];
    [_webview setFrame:CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
    _webview.H5URL = _H5URL;
    _webview.customURL = self.targetURL;
    _webview.mjwebviewDelegate=self;
    [self.view addSubview:_webview];
    

    //navi
    UIView * navibg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT + 44)];
    navibg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navibg];

    //cancel
    MJButton * backBtn = [[MJButton alloc]initWithFrame:CGRectMake(16, STATUS_BAR_HEIGHT+8, 55, 26)];
    backBtn.mj_imageObjec=[UIImage getBundleImage:@"sz_naviback_black"];
    backBtn.imageFrame=CGRectMake(10, 5, 8.5, 14.5);
    backBtn.mj_font=BOLD_FONT(15);
    backBtn.mj_textColor=HW_BLACK;
    [backBtn addTarget:self action:@selector(navibackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    //title
    titleLabel = [[UILabel alloc]init];
    [titleLabel setFrame:CGRectMake(SCREEN_WIDTH/2-80, STATUS_BAR_HEIGHT, 160, 44)];
    titleLabel.textColor=HW_BLACK;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=BOLD_FONT(18);
    titleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction)];
    [titleLabel addGestureRecognizer:tap];
    [self.view addSubview:titleLabel];

    //cancel
    shareBtn = [[MJButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, STATUS_BAR_HEIGHT+8, 55, 26)];
    shareBtn.mj_imageObjec=[UIImage getBundleImage:@"sz_naviShare"];
    shareBtn.imageFrame=CGRectMake(10, 9, 20, 4);
    shareBtn.mj_font=BOLD_FONT(15);
    shareBtn.mj_textColor=HW_BLACK;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.hidden=YES;
    [self.view addSubview:shareBtn];
    
    //判断是否显示评论框
    if (self.contentId.length)
    {
        //添加评论栏
        SZCommentBar * commentBar = [[SZCommentBar alloc]init];
        [commentBar setCommentBarStyle:0 type:1];
        [self.view addSubview:commentBar];
    }
}



#pragma mark - MJWebview Delegate
-(void)mjWebview:(UIView *)view passValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"webTitle"])
    {
        NSString * titleStr = value;
        titleLabel.text = titleStr;
    }
    else if ([key isEqualToString:@"webback"])
    {
        [self navibackAction];
    }
}


#pragma mark - BtnActions
-(void)navibackAction
{
    if (H5KeyboardShow)
    {
        [self.view.window endEditing:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)shareBtnAction
{
    SZContentModel * content = [SZContentModel model];
    content.shareUrl = self.shareUrl;
    content.shareBrief = self.shareBrief;
    content.shareTitle = self.shareTitle;
    content.shareImageUrl = self.shareImg;

    [MJHUD_Selection showShareView:^(id objc) {
        NSNumber * number = objc;
        SZ_SHARE_PLATFORM plat = number.integerValue;

        [SZGlobalInfo mjshareToPlatform:plat content:content source:@"底部分享"];
    }];
}

-(void)titleTapAction
{
    
}

-(void)updateCurrentContentId
{
    //focus
    if (self.contentId.length)
    {
        //配置数据到dic
        SZContentModel * model = [SZContentModel model];
        model.shareUrl=self.shareUrl;
        model.shareBrief = self.shareBrief;
        model.shareTitle = self.shareTitle;
        model.shareImageUrl = self.shareImg;
        model.id = self.contentId;
        model.disableComment = self.disableComment;
        [[SZData sharedSZData].contentDetailDic setValue:model forKey:self.contentId];
        
        //设置currentContentId
        [SZData sharedSZData].currentContentId = self.contentId;
    }
}

@end

