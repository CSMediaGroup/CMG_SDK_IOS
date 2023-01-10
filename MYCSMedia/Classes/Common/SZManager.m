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
#import "SZUserTracker.h"
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
            [SZUserTracker shareTracker];
            
            [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        }
        });
    return manager;
}

+(void)initWithAppId:(NSString*)appid appKey:(NSString*)appkey appDelegate:(id<SZDelegate>)delegate enviroment:(SZ_ENV)env
{
    if (appid.length==0 ||appkey.length==0)
    {
        NSLog(@"请传入appid 和 appkey");
    }
    else if (delegate==nil)
    {
        NSLog(@"请传入delegate");
    }
    
    SZManager * manager =  [SZManager sharedManager];
    manager.delegate=delegate;
    manager.enviroment=env;
    manager.appid=appid;
    manager.appkey=appkey;
    
    [[SZGlobalInfo sharedManager]requestThirdPartAppInfo:nil];
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

+ (void)routeToDetailPage:(UINavigationController *)nav content:(SZContentModel *)data
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
