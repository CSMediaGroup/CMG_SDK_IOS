//
//  SZMediaVC.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/10.
//

#import "SZMediaVC.h"
#import "SZGlobalInfo.h"
#import "SZThirdAppInfo.h"
#import "MJHUD.h"

@interface SZMediaVC ()

@end

@implementation SZMediaVC

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        if ([SZManager sharedManager].appid.length==0)
        {
            [self installNoticeView:@"SDK初始化失败" error:0];
        }
        else if ([SZGlobalInfo sharedManager].thirdApp.config.listUrl.length==0)
        {
            [self installNoticeView:@"网络开小差了，返回后重试" error:1];
        }
        else
        {
            self.H5URL = [SZGlobalInfo sharedManager].thirdApp.config.listUrl;
        }
        
    }
    return self;
}

-(void)installNoticeView:(NSString*)msg error:(NSInteger)type
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 30)];
    label.text=msg;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:17];
    label.userInteractionEnabled=YES;
    [self.view addSubview:label];
    if (type==1)
    {
        UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [label addGestureRecognizer:tap];
    }
}

-(void)tapAction
{
    [self.navigationController popViewControllerAnimated: NO];
}





@end
