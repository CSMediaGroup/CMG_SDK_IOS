//
//  SZManager.m
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/28.
//

#import "SZManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SZTokenExchangeModel.h"
#import "SZDefines.h"
#import "MJHud.h"
#import "SZGlobalInfo.h"
#import "SZPanelListModel.h"
#import "SZThirdAppConfig.h"
#import "SZThirdAppInfo.h"
#import "UIDevice+MJCategory.h"
#import "SZPanelModel.h"
#import "SZVideoDetailVC.h"
#import "SZWebVC.h"
#import "NSObject+MJCategory.h"
#import "SZContentListModel.h"

@implementation SZManager


+(SZManager *)sharedManager
{
    static SZManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil)
        {
            manager = [[SZManager alloc]init];
            
            [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        }
        });
    return manager;
}

+(void)initWithAppId:(NSString*)appid appKey:(NSString*)appkey appDelegate:(id<SZDelegate>)delegate enviroment:(SZ_ENV)env
{
    if (appid.length ==NO || appkey.length ==NO)
    {
        @throw @"请传入appid 和 appkey";
    }
    else if (delegate==nil)
    {
        @throw @"请设置delegate";
    }
    else if ([delegate respondsToSelector:@selector(onShareAction:title:image:desc:URL:)]==NO)
    {
        @throw @"请实现代理方法 onShareAction";
    }
    else if ([delegate respondsToSelector:@selector(onLoginAction)]==NO)
    {
        @throw @"请实现代理方法 onLoginAction";
    }
    else if ([delegate respondsToSelector:@selector(onGetUserInfo)]==NO)
    {
        @throw @"请实现代理方法 onGetUserInfo";
    }
    else
    {
        SZManager * manager =  [SZManager sharedManager];
        manager.delegate=delegate;
        manager.enviroment=env;
        manager.appid=appid;
        manager.appkey=appkey;
        
        [[SZManager sharedManager]fetchAppInfo];
    }
    
    
}

-(void)fetchAppInfo
{
    static int k = 0;
    [[SZGlobalInfo sharedManager]requestThirdPartAppInfo:^(id rest) {
        if (rest==nil)
        {
            k++;
            if (k<10)
            {
                NSLog(@"retry");
                [self performSelector:@selector(fetchAppInfo) withObject:nil afterDelay:0];
            }
            
        }
    }];
}




+(void)requestContentList:(NSNumber*)pagesize callback:(NSDictionary*)callbackDic
{
    SuccessBlock sucblock = [callbackDic valueForKey:@"success"];
    ErrorBlock errorblock = [callbackDic valueForKey:@"error"];
    FailBlock failblock = [callbackDic valueForKey:@"fail"];
    [SZManager requestContentList:pagesize.integerValue Success:sucblock Error:errorblock Fail:failblock];
    
}

+(void)requestContentList:(NSInteger)pagesize Success:(RMSuccessBlock)successblock Error:(RMErrorBlock)errorblock Fail:(RMFailBlock)failblock
{
    SZPanelListModel * panelListM = [SZPanelListModel model];
    
    SZGlobalInfo * info = [SZGlobalInfo sharedManager];
    NSString * catecode = info.thirdApp.config.categoryCode;
    NSString * deviceId = [UIDevice getIDFA];
    
    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    [param setValue:catecode forKey:@"categoryCode"];
    [param setValue:@"1" forKey:@"personalRec"];
    [param setValue:@"open" forKey:@"refreshType"];
    [param setValue:[NSNumber numberWithInteger:pagesize] forKey:@"pageSize"];
    [param setValue:deviceId forKey:@"ssid"];
    
    [panelListM GETRequestInView:nil WithUrl:APPEND_SUBURL(BASE_URL, API_URL_PANNEL_LIST_URL) Params:param Success:^(id responseObject) {
        
        NSArray * pannelArr = panelListM.dataArr;
        NSMutableArray * contentsArr = [NSMutableArray array];
        for (int i = 0; i<pannelArr.count; i++)
        {
            SZPanelModel * pannelM = pannelArr[i];
            [contentsArr addObjectsFromArray:pannelM.dataArr];
        }
        successblock(contentsArr);
        } Error:^(id responseObject) {
            errorblock(panelListM.message);
        } Fail:^(NSError *error) {
            failblock(error);
        }];
}

+(void)requestMoreContentList:(NSInteger)pagesize LastContent:(SZContentModel *)content Success:(RMSuccessBlock)successblock Error:(RMErrorBlock)errorblock Fail:(RMFailBlock)failblock
{
    SZContentListModel * listm = [SZContentListModel model];
    
    SZGlobalInfo * info = [SZGlobalInfo sharedManager];
    NSString * pannelId = info.thirdApp.config.panId;
    NSString * deviceId = [UIDevice getIDFA];
    
    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    [param setValue:[NSNumber numberWithInteger:pagesize] forKey:@"pageSize"];
    [param setValue:pannelId forKey:@"panelId"];
    [param setValue:content.id forKey:@"contentId"];
    [param setValue:content.vernier forKey:@"vernier"];
    [param setValue:deviceId forKey:@"ssid"];
    [param setValue:@"1" forKey:@"personalRec"];
    [param setValue:@"loadmore" forKey:@"refreshType"];
    
    [listm GETRequestInView:nil WithUrl:APPEND_SUBURL(BASE_H5_URL, API_URL_PANNEL_LIST_MORE) Params:param Success:^(id responseObject) {
        successblock(listm.dataArr);
        } Error:^(id responseObject) {
            errorblock(listm.message);
        } Fail:^(NSError *error) {
            failblock(error);
        }];
    
}

+(void)routeToDetailPage:(UINavigationController *)nav content:(SZContentModel *)data
{
    if ([data.type isEqualToString:@"short_video"])
    {
        SZVideoDetailVC * vc =[[SZVideoDetailVC alloc]init];
        vc.contentId = data.id;
        vc.detailType = 0;
        [nav pushViewController:vc animated:YES];
    }
    else
    {
        SZWebVC * vc = [[SZWebVC alloc]init];
        vc.H5URL = data.detailUrl;
        
        vc.shareTitle = data.shareTitle;
        vc.shareImg = data.shareImageUrl;
        vc.shareBrief = data.shareBrief;
        vc.shareUrl = data.shareUrl;
        [nav pushViewController:vc animated:YES];
    }
}

@end
