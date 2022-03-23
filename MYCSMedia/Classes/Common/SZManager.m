//
//  SZManager.m
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/28.
//

#import "SZManager.h"
#import <AFNetworking/AFNetworking.h>
#import "TokenExchangeModel.h"
#import "SZDefines.h"
#import "MJHud.h"
#import "SZUserTracker.h"
#import "SZGlobalInfo.h"

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
    
    [[SZGlobalInfo sharedManager]requestThirdPartAppInfo];
}





@end
