//
//  SZVideoCell.m
//  智慧长沙
//
//  Created by 马佳 on 2019/11/13.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//


#import "SZVideoCell.h"
#import <Masonry/Masonry.h>
#import "SZDefines.h"
#import "UIColor+MJCategory.h"
#import "MJVideoManager.h"
#import "MJButton.h"
#import "UIImage+MJCategory.h"
#import "NSString+MJCategory.h"
#import <SDWebImage/SDWebImage.h>
#import "SZGlobalInfo.h"
#import "UIView+MJCategory.h"
#import "MJHUD.h"
#import "SZContentModel.h"
#import "SZVideoCollectModel.h"
#import "MJLabel.h"
#import "UIScrollView+MJCategory.h"
#import "GYRollingNoticeView.h"
#import "GYNoticeCell.h"
#import "SZData.h"
#import "SZVideoRelateModel.h"
#import "NSAttributedString+YYText.h"
#import "SZStrUtils.h"
#import "MJProgressView.h"
#import "SZDefaultControlView.h"
#import "SZContentStateModel.h"
#import "UIResponder+MJCategory.h"
#import "SZContentListModel.h"
#import "SZVideoDetailVC.h"
#import "SZThirdAppInfo.h"
#import "YYText.h"
#import "SZSideBar.h"
#import "YPDouYinLikeAnimation.h"

@interface SZVideoCell ()<GYRollingNoticeViewDelegate,GYRollingNoticeViewDataSource>

@end

@implementation SZVideoCell
{
    //data
    SZContentModel * dataModel;
    SZVideoRelateModel * relateModel;
    SZVideoCollectModel * collectModel;
    NSString * cellAlbumnName;  //合集名称
    NSInteger videoWHSize;                       //9:16 -- 0          16:9 -- 2        其他比例 -- 1
    
    
    //UI
    UIImageView * videoCoverImage;
    UIImageView * logoImage;
    YYLabel * descLabel;
    MJButton * selecBtn;
    GYRollingNoticeView * rollingNoticeView;
    UILabel * authorName;
    UILabel * viewCountLabel;
    SZSideBar * sideBar;
    
    UIView * authorBG;
    UIImageView * avatar;
    UIImageView * levelIcon;
    MJButton * followBtn;
    
    MJProgressView * videoSlider;
    
    NSMutableArray * videoBtns;
    
    NSArray * belongAlbumArr;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor blackColor];
        
        //视频
        CGFloat videoHeight = SCREEN_WIDTH*0.56;
        videoCoverImage = [[UIImageView alloc]init];
        videoCoverImage.userInteractionEnabled=YES;
        videoCoverImage.backgroundColor=HW_BLACK;
        videoCoverImage.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:videoCoverImage];
        [videoCoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-15);
            make.height.mas_equalTo(videoHeight);
        }];
        
        
        //顶部遮罩
        UIImageView * topmask = [[UIImageView alloc]init];
        topmask.image=[UIImage getBundleImage:@"sz_video_mask1"];
        [self.contentView addSubview:topmask];
        [topmask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(STATUS_BAR_HEIGHT+100);
        }];
        
        
        //底部遮罩
        UIImageView * bottomMask = [[UIImageView alloc]init];
        bottomMask.image=[UIImage getBundleImage:@"sz_video_mask2"];
        [self.contentView addSubview:bottomMask];
        
        
        //Logo
        logoImage = [[UIImageView alloc]init];
        logoImage.contentMode=UIViewContentModeScaleAspectFill;
        SZThirdAppInfo * appinfo = [SZGlobalInfo sharedManager].thirdApp;
        [logoImage sd_setImageWithURL:[NSURL URLWithString:appinfo.logo]];
        [self.contentView addSubview:logoImage];
        
        //简述(包含话题)
        CGFloat SafeAreaOffset = self.height==SCREEN_HEIGHT?  (-BOTTOM_SAFEAREA_HEIGHT) : 0;
        descLabel = [[YYLabel alloc]init];
        descLabel.numberOfLines=2;
        descLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        descLabel.textColor=HW_GRAY_WORD_1;
        descLabel.userInteractionEnabled=YES;
        descLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-42;
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(21);
            make.width.mas_equalTo(SCREEN_WIDTH-100);
            make.bottom.mas_equalTo(SafeAreaOffset-48);
        }];
        

        
        //作者bg
        authorBG = [[UIView alloc]init];
        authorBG.backgroundColor=[UIColor blackColor];
        authorBG.layer.cornerRadius=14;
        [authorBG MJSetIndividualAlpha:0.3];
        [self addSubview:authorBG];

        
        //作者头像
        avatar = [[UIImageView alloc]init];
        avatar.userInteractionEnabled=YES;
        avatar.layer.cornerRadius=16;
        avatar.layer.masksToBounds=YES;
        [self addSubview:avatar];
        avatar.backgroundColor=[UIColor whiteColor];
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(authorBG.mas_left);
            make.centerY.mas_equalTo(authorBG);
            make.width.height.mas_equalTo(32);
        }];
        
        
        //作者名
        authorName = [[UILabel alloc]init];
        authorName.font = FONT(16);
        authorName.textColor=HW_WHITE;
        authorName.userInteractionEnabled = YES;
        [self addSubview:authorName];
        [authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).offset(5);
            make.centerY.mas_equalTo(authorBG);
            make.width.mas_lessThanOrEqualTo(140);
        }];
        
        
        //用户星级
        levelIcon = [[UIImageView alloc]init];
        [self addSubview:levelIcon];
        [levelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(authorName.mas_right).offset(7);
            make.centerY.mas_equalTo(authorName);
            make.width.height.mas_equalTo(13);
        }];
        
        
        //关注按钮
        followBtn = [[MJButton alloc]init];
        followBtn.mj_bgColor = HW_RED_WORD_1;
        followBtn.mj_text = @"关注";
        followBtn.mj_text_sel = @"已关注";
        followBtn.mj_textColor=HW_WHITE;
        followBtn.mj_bgColor_sel=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        followBtn.mj_font = FONT(12);
        followBtn.layer.cornerRadius = 11;
        [self addSubview:followBtn];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(levelIcon.mas_right).offset(7);
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(levelIcon);
            make.width.mas_equalTo(40);
        }];
        
        
        //滚动通知
        rollingNoticeView = [[GYRollingNoticeView alloc]init];
        rollingNoticeView.delegate = self;
        rollingNoticeView.dataSource = self;
        [self addSubview:rollingNoticeView];
        [rollingNoticeView registerClass:[GYNoticeCell class] forCellReuseIdentifier:@"gynoticecellid"];
        [rollingNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(descLabel.mas_left).offset(-3);
            make.bottom.mas_equalTo(descLabel.mas_top).offset(-13);
            make.width.mas_equalTo(descLabel.mas_width);
            make.height.mas_equalTo(46);//36
        }];
        
        
        
        //观看数
        viewCountLabel = [[UILabel alloc]init];
        viewCountLabel.textColor=HW_WHITE;
        viewCountLabel.font=FONT(12);
        [self addSubview:viewCountLabel];
        [viewCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(descLabel.mas_left).offset(3);
            make.bottom.mas_equalTo(authorBG.mas_top).offset(-10);
        }];
        
        //底部遮罩
        [bottomMask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.top.mas_equalTo(viewCountLabel.mas_top).offset(-50);
        }];
        
        //侧边工具栏
        sideBar = [[SZSideBar alloc]init];
        [self addSubview:sideBar];
        [sideBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(descLabel.mas_bottom).offset(6);
            make.width.mas_equalTo(20+20+30);
            make.height.mas_equalTo(170);
        }];
        
        //双击(播放/暂停)
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTouchesRequired = 1; //手指数
        doubleTap.numberOfTapsRequired    = 2;
        [self addGestureRecognizer:doubleTap];
        
        //数据监听
        [self addDataBinding];
        
    }
    return self;
}




#pragma mark - SetCellData
-(void)setVideoCellData:(SZContentModel*)objc albumnName:(NSString *)albumnName simpleMode:(BOOL)simple
{
    //model
    dataModel = objc;
    
    //合集名（视频详情，且是合集类型时，用到该字段）
    cellAlbumnName = albumnName;
    
    //简版模式
    sideBar.hidden=simple;
    viewCountLabel.hidden=simple;
    
    //修改播放器尺寸
    [self updateVideoBGLayout];
    
    //封面图
    [videoCoverImage sd_setImageWithURL:[NSURL URLWithString:dataModel.imagesUrl]];
    videoCoverImage.layer.masksToBounds=YES;
    
    
    //观看数
    if (dataModel.viewCountShow)
    {
        NSString * viewsStr = [NSString converToViewCountStr:dataModel.viewCountShow];
        viewCountLabel.text = [NSString stringWithFormat:@"%@人看过",viewsStr];
    }
    else
    {
        viewCountLabel.text = @"";
    }
    
    [viewCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descLabel.mas_left).offset(3);
        make.bottom.mas_equalTo(authorBG.mas_top).offset(-10);
    }];
    
    
    //如果是视频详情且有合集名称
    if (cellAlbumnName.length)
    {
        //合辑图标
        UIImage * img = [UIImage getBundleImage:@"sz_videoCollection"];
        UIImageView * imgv = [[UIImageView alloc]initWithImage:img];
        [imgv setFrame:CGRectMake(0, 5, 13, 13)];
        
        NSMutableAttributedString * attstr = [NSMutableAttributedString yy_attachmentStringWithContent:imgv contentMode:UIViewContentModeScaleAspectFit attachmentSize:imgv.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        
        
        //插一个space
        UIView * space = [[UIView alloc]init];
        [space setSize:CGSizeMake(6, 0)];
        NSMutableAttributedString * tempattstr = [NSMutableAttributedString yy_attachmentStringWithContent:space contentMode:UIViewContentModeScaleAspectFit attachmentSize:space.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
        [attstr appendAttributedString:tempattstr];
        
        //拼专辑
        NSMutableAttributedString * attstr_album = [[NSMutableAttributedString alloc]initWithString:cellAlbumnName];
        [attstr appendAttributedString:attstr_album];
        
        
        //插一个space
        UIView * space2 = [[UIView alloc]init];
        [space2 setSize:CGSizeMake(6, 0)];
        NSMutableAttributedString * tempattstr2 = [NSMutableAttributedString yy_attachmentStringWithContent:space2 contentMode:UIViewContentModeScaleAspectFit attachmentSize:space2.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
        [attstr appendAttributedString:tempattstr2];
        
        //拼简介
        NSString * finalDesc = dataModel.brief.length>0 ? dataModel.brief:dataModel.title;
        NSMutableAttributedString * attstr_desc = [[NSMutableAttributedString alloc]initWithString:finalDesc];
        [attstr appendAttributedString:attstr_desc];
        
        
        //设置合集标题样式
        NSRange range3 = [attstr.string rangeOfString:cellAlbumnName];
        [attstr yy_setTextHighlightRange:range3 color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        }];
        [attstr yy_setFont:[UIFont systemFontOfSize:15] range:range3];
        

        //设置简介点击事件和样式
        __weak typeof (self) weakSelf = self;
        NSRange range1 = [attstr.string rangeOfString:finalDesc];
        [attstr yy_setTextHighlightRange:range1 color:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weakSelf descClickAction];
        }];
        [attstr yy_setFont:[UIFont systemFontOfSize:14] range:range1];
        
        //设置整体行间距
        [attstr yy_setLineSpacing:4 range:NSMakeRange(0,attstr.string.length)];


        descLabel.attributedText = attstr;
        descLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    }
    else
    {
        //有简介显示简介，没简介显示标题
        NSString * finalDesc = dataModel.brief.length>0 ? dataModel.brief:dataModel.title;

        //设置简介样式
        __weak typeof (self) weakSelf = self;
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:finalDesc];
        [mutableString yy_setTextHighlightRange:NSMakeRange(0, finalDesc.length) color:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weakSelf descClickAction];
        }];
        [mutableString yy_setFont:[UIFont systemFontOfSize:13] range:NSMakeRange(0, finalDesc.length)];
        [mutableString yy_setLineSpacing:4 range:NSMakeRange(0,finalDesc.length)];
        descLabel.attributedText = mutableString;
        descLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        
    }
    
    //昵称
    authorName.text = dataModel.issuerName;
    
    
    //头像
    [avatar sd_setImageWithURL:[NSURL URLWithString:dataModel.issuerImageUrl]];
    
    
    //蓝V认证
    if ([dataModel.creatorCertMark isEqualToString:@"blue-v"])
    {
        levelIcon.image = [UIImage getBundleImage:@"sz_level_blue"];
        levelIcon.hidden=NO;

    }
    
    //黄V认证
    else if ([dataModel.creatorCertMark isEqualToString:@"yellow-v"])
    {
        levelIcon.image = [UIImage getBundleImage:@"sz_level_yellow"];
        levelIcon.hidden=NO;
    }
    
    //普通用户
    else
    {
        levelIcon.image = nil;
        levelIcon.hidden=YES;
    }
    
    
    
    //默认隐藏通知条
    rollingNoticeView.hidden=YES;
    
    
    //是否是UGC系统
    if (dataModel.issuerId.length>0)
    {
        //如果当前登录用户是自己
        if ([[SZGlobalInfo sharedManager].SZRMUserId isEqualToString:dataModel.createBy])
        {
            followBtn.hidden=YES;
            avatar.userInteractionEnabled = YES;
            authorName.userInteractionEnabled = YES;
            
            [authorBG mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(descLabel.mas_top).offset(-10);
                make.left.mas_equalTo(descLabel.mas_left);
                make.height.mas_equalTo(28);
                make.right.mas_equalTo(authorName.mas_right).offset(10);
            }];
        }
        else
        {
            followBtn.hidden = NO;
            avatar.userInteractionEnabled = YES;
            authorName.userInteractionEnabled = YES;
            
            [authorBG mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(descLabel.mas_top).offset(-10);
                make.left.mas_equalTo(descLabel.mas_left);
                make.height.mas_equalTo(28);
                make.right.mas_equalTo(followBtn.mas_right).offset(5);
            }];
        }
    }
    
    
    //PGC系统
    else
    {
        followBtn.hidden = YES;
        
        avatar.userInteractionEnabled = NO;
        authorName.userInteractionEnabled = NO;
        
        [authorBG mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(descLabel.mas_top).offset(-10);
            make.left.mas_equalTo(descLabel.mas_left);
            make.height.mas_equalTo(28);
            make.right.mas_equalTo(authorName.mas_right).offset(10);
        }];
    }
    
}



-(void)updateVideoBGLayout
{
    
    //视频宽高比
    CGFloat imageWidth = dataModel.width.floatValue > 0 ? dataModel.width.floatValue : 1920;
    CGFloat imageHeight = dataModel.height.floatValue > 0 ? dataModel.height.floatValue : 1080;
    CGFloat WHRate = imageWidth / imageHeight;
    
    
    //9:16  0.562左右   撑满
    if (WHRate<0.57)
    {
        videoWHSize = 0;

        //如果是刘海屏
        if ([UIApplication sharedApplication].statusBarFrame.size.height>20)
        {
            [videoCoverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        
        //非刘海屏
        else
        {
            [videoCoverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        
        //logo
        [logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(STATUS_BAR_HEIGHT+44+22);
            make.width.height.mas_equalTo(32);
        }];
        
    }
    
    
    
    //16:9  (1.77)左右     居中
    else if(WHRate<1.80 && WHRate >1.70)
    {
        videoWHSize = 1;
        
        CGFloat videoH = SCREEN_WIDTH / WHRate;
        [videoCoverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(videoH);
        }];
        
        //logo
        [logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(videoCoverImage.mas_top).offset(-23);
            make.width.height.mas_equalTo(32);
        }];
    }
    
    
    //其他比例的视频
    else
    {
        videoWHSize = 2;
        
        CGFloat videoH = SCREEN_WIDTH / WHRate;
        [videoCoverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(videoH);
        }];
        
        //logo
        [logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(STATUS_BAR_HEIGHT+44+22);
            make.width.height.mas_equalTo(32);
        }];
    }
    
}


#pragma mark - 数据绑定 与 回调
-(void)addDataBinding
{
    //绑定数据
    [self bindModel:[SZData sharedSZData]];
    
    __weak typeof (self) weakSelf = self;
    self.observe(@"contentRelateUpdateTime",^(id value){
        [weakSelf updateVideoRelate];
    }).observe(@"currentContentId",^(id value){
        [weakSelf currentContentIdDidChange:value];
    }).observe(@"contentCreateFollowTime",^(id value){
        [weakSelf currentFollowStateDidChange];
    }).observe(@"contentStateUpdateTime",^(id value){
        [weakSelf currentFollowStateDidChange];
    }).observe(@"contentBelongAlbumsUpdateTime",^(id value){
        [weakSelf updateVideoRelateAlbum];
    }).observe(@"isShowCommentBG",^(id value){
        [weakSelf showCommentBG:value];
    });;
}



//视频相关新闻(滚动通知条)
-(void)updateVideoRelate
{
    NSString * contentId = [SZData sharedSZData].currentContentId;
    
    if (rollingNoticeView.superview==nil)
    {
        return;
    }
    
    if ([dataModel.id isEqualToString:contentId])
    {
        SZData * szdata = [SZData sharedSZData];
        
        relateModel = [szdata.contentRelateContentDic valueForKey:contentId];
        
        NSString * isdislike = [szdata.contentRelateContentDislikeDic valueForKey:contentId];
        
        //如果不喜欢推荐
        if (isdislike || relateModel.dataArr.count==0)
        {
            [rollingNoticeView stopRoll];
            rollingNoticeView.hidden=YES;
        }
        
        //如果有相关推荐
        else
        {
            rollingNoticeView.hidden=NO;
            [authorBG mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(descLabel.mas_top).offset(-58);
            }];
            [rollingNoticeView reloadDataAndStartRoll];
            
        }

    }
}


//视频所在合辑
-(void)updateVideoRelateAlbum
{
    NSString * contentId = [SZData sharedSZData].currentContentId;
    
    if ([dataModel.id isEqualToString:contentId])
    {
        SZData * szdata = [SZData sharedSZData];
        SZContentListModel * listM = [szdata.contentBelongAlbumsDic valueForKey:contentId];
        
        if (listM.dataArr.count>0)
        {
            belongAlbumArr = listM.dataArr;
    
            
            //合辑图标
            UIImage * img = [UIImage getBundleImage:@"sz_videoCollection"];
            UIImageView * imgv = [[UIImageView alloc]initWithImage:img];
            [imgv setFrame:CGRectMake(0, 5, 13, 13)];
            
            NSMutableAttributedString * attstr = [NSMutableAttributedString  yy_attachmentStringWithContent:imgv contentMode:UIViewContentModeScaleAspectFit attachmentSize:imgv.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
            
            
            //插一个space
            UIView * space = [[UIView alloc]init];
            [space setSize:CGSizeMake(6, 0)];
            NSMutableAttributedString * tempattstr = [NSMutableAttributedString  yy_attachmentStringWithContent:space contentMode:UIViewContentModeScaleAspectFit attachmentSize:space.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
            [attstr appendAttributedString:tempattstr];
            
            
            //插入合集标题和分隔符
            for (int i=0; i<belongAlbumArr.count; i++)
            {
                SZContentModel * album = belongAlbumArr[i];
                
                if (i>0)
                {
                    //拼分隔符
                    UIView * sepaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 16)];
                    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(4.5, 5, 1, 12)];
                    line.backgroundColor=[UIColor whiteColor];
                    [sepaView addSubview:line];
                    
                    NSMutableAttributedString * tempattstr = [NSMutableAttributedString  yy_attachmentStringWithContent:sepaView contentMode:UIViewContentModeScaleAspectFit attachmentSize:sepaView.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
                    [attstr appendAttributedString:tempattstr];

                }
                
                //拼标题
                NSMutableAttributedString * attstr_album = [[NSMutableAttributedString alloc]initWithString:album.title];
                [attstr appendAttributedString:attstr_album];
            }
            
            
            //插一个space
            UIView * space2 = [[UIView alloc]init];
            [space2 setSize:CGSizeMake(6, 0)];
            NSMutableAttributedString * tempattstr2 = [NSMutableAttributedString  yy_attachmentStringWithContent:space2 contentMode:UIViewContentModeScaleAspectFit attachmentSize:space2.size alignToFont:[UIFont systemFontOfSize:24] alignment:YYTextVerticalAlignmentCenter];
            [attstr appendAttributedString:tempattstr2];
            
            
            //拼简介
            NSString * finalDesc = dataModel.brief.length>0 ? dataModel.brief:dataModel.title;
            NSMutableAttributedString * attstr_desc = [[NSMutableAttributedString alloc]initWithString:finalDesc];
            [attstr appendAttributedString:attstr_desc];
            

            //设置简介点击事件和样式
            __weak typeof (self) weakSelf = self;
            NSRange range1 = [attstr.string rangeOfString:finalDesc];
            [attstr  yy_setTextHighlightRange:range1 color:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [weakSelf descClickAction];
            }];
            [attstr  yy_setFont:[UIFont systemFontOfSize:14] range:range1];
            

            //分别设置每个合集标题的点击事件和样式
            for (int i = 0; i<belongAlbumArr.count; i++)
            {
                SZContentModel * album = belongAlbumArr[i];
                NSRange range3 = [attstr.string rangeOfString:album.title];
                [attstr  yy_setTextHighlightRange:range3 color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    NSString * substr = [[text string]substringWithRange:range];
                    [weakSelf albumClickAction:substr];
                }];
                [attstr  yy_setFont:[UIFont systemFontOfSize:15] range:range3];
            }

            //设置整体行间距
            [attstr  yy_setLineSpacing:4 range:NSMakeRange(0,attstr.string.length)];


            descLabel.attributedText = attstr;
            descLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            
        }
    }
}


//contentId有更新
-(void)currentContentIdDidChange:(NSString*)currentId
{
    //如果当前ID与cell持有的内容ID相同，则表示播放该视频
    if ([dataModel.id isEqualToString:currentId])
    {
        //判断是否当前VC在顶层
        UIViewController * vc = [self getCurrentViewController];
        UINavigationController * nav = [self getCurrentNavigationController];
        if ([nav.topViewController isEqual:vc])
        {
            [self playingVideo];
        }
    }
}


//关注状态变化
-(void)currentFollowStateDidChange
{
    NSString * contentId = [SZData sharedSZData].currentContentId;
    if ([dataModel.id isEqualToString:contentId])
    {
        //是否已关注
        SZContentStateModel * stateM = [[SZData sharedSZData].contentStateDic valueForKey:contentId];
        if (stateM.whetherFollow)
        {
            followBtn.MJSelectState=YES;
            [followBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(50);
            }];
        }
        else
        {
            followBtn.MJSelectState=NO;
            [followBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(40);
            }];
        }
    }
}

//显示评论
-(void)showCommentBG:(NSString*)value
{
    NSString * contentId = [SZData sharedSZData].currentContentId;
    if ([dataModel.id isEqualToString:contentId])
    {
        if (value.boolValue==YES)
        {
            CGFloat height = SCREEN_HEIGHT * 0.3;
            [UIView animateWithDuration:0.1 animations:^{
                [self->videoCoverImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(SCREEN_WIDTH);
                    make.height.mas_equalTo(height);
                }];
            }];
        }
        else
        {
            [self updateVideoBGLayout];
        }

    }
}


#pragma mark - 播放视频
-(void)playingVideo
{
    //播放视频
    NSInteger renderMode = 0;

    if (videoWHSize==0)
    {
        //剪切
        renderMode = 0;
    }
    else
    {
        //缩放
        renderMode = 1;
    }

    [MJVideoManager playWindowVideoAtView:videoCoverImage url:dataModel.playUrl SZContentModel:dataModel renderModel:renderMode];

    //获取进度条
    SZDefaultControlView * controlView =  (SZDefaultControlView*)[MJVideoManager videoPlayer].controlView;
    videoSlider = controlView.externalSlider;
    videoSlider.hidden=NO;
    [self insertSubview:videoSlider belowSubview:descLabel];

    //进度条改成永远在下方
    CGFloat sliderOffset = self.height==SCREEN_HEIGHT?  (-BOTTOM_SAFEAREA_HEIGHT) : 0;
    [videoSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(sliderOffset);
    }];


    //获取全屏按钮
    [self insertSubview:controlView.externalFullScreenBtn belowSubview:descLabel];
    if (videoWHSize==0 || videoWHSize==2)
    {
        [controlView.externalFullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(videoCoverImage);
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(0);
            make.top.mas_equalTo(videoCoverImage.mas_bottom).offset(44);
        }];
    }
    else
    {
        [controlView.externalFullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(videoCoverImage);
            make.height.mas_equalTo(29);
            make.width.mas_equalTo(82);
            make.top.mas_equalTo(videoCoverImage.mas_bottom).offset(44);
        }];
    }
    
}

#pragma mark - Double Tap
-(void)doubleTapAction:(UITapGestureRecognizer*)gest
{
    //未登录则跳转登录
    if (![SZGlobalInfo sharedManager].SZRMToken.length)
    {
        [SZGlobalInfo mjshowLoginAlert];
        return;
    }
    [[SZData sharedSZData]DoubleTapZanAction];
    [[YPDouYinLikeAnimation shareInstance]createAnimationWithTap:gest];
}



#pragma mark - Btn Action
//播放按钮
-(void)videoBtnAction
{
    [self playingVideo];
}


//简介
-(void)descClickAction
{
    
    YYLabel * label =  descLabel;
    if (label.numberOfLines < 2)
    {
        label.numberOfLines = 2;
    }
    else
    {
        label.numberOfLines = 0;
    }
}

//合辑名称
-(void)albumClickAction:(NSString*)albumTitle
{
    //这个功能先取消
    
//    //如果已经在合辑列表了，则不能再点下级页面了
//    if (albumName.length)
//    {
//        return;
//    }
//
//    for (int i = 0; i<belongAlbumArr.count; i++)
//    {
//        SZContentModel * album = belongAlbumArr[i];
//        if ([album.title isEqualToString:albumTitle])
//        {
//            //视频合集
//            UINavigationController * nav = [self getCurrentNavigationController];
//            SZVideoDetailVC * vc = [[SZVideoDetailVC alloc]init];;
//            vc.albumId = album.id;
//            vc.detailType=1;
//            vc.albumName=albumTitle;
//            [nav pushViewController:vc animated:YES];
//        }
//    }
}

//全屏播放按钮
-(void)fullScreenBtnAction
{
    NSNumber * num = [NSNumber numberWithBool:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MJRemoteEnterFullScreen" object:num];
}

#pragma mark - GYScroll Delegate  滚动通知栏
-(NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return relateModel.dataArr.count;
}

-(__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    GYNoticeCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"gynoticecellid"];
    
    SZVideoRelateModel * relateM = relateModel.dataArr[index];
    [cell setCellData:relateM];
    return cell;
}
-(void)didClickCloseBtnAction
{
    [rollingNoticeView stopRoll];
    rollingNoticeView.hidden=YES;
    
    //保存不喜欢
    [[SZData sharedSZData].contentRelateContentDislikeDic setValue:@"1" forKey:dataModel.id];
    
    [authorBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(descLabel.mas_top).offset(-13);
    }];
}


@end
