//
//  SZGlobalInfo.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/5.
//

#import "SZGlobalInfo.h"
#import <AFNetworking/AFNetworking.h>
#import "TokenExchangeModel.h"
#import "SZDefines.h"
#import "MJHud.h"
#import "SZManager.h"
#import "SZUserTracker.h"
#import "SZData.h"
#import "YYModel.h"

@interface SZGlobalInfo ()
@property(strong,nonatomic)LoginCallback loginResult;
@end


@implementation SZGlobalInfo


+(SZGlobalInfo *)sharedManager
{
    static SZGlobalInfo * info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (info == nil)
        {
            info = [[SZGlobalInfo alloc]init];
            
            [info mjloadLocalData];
        }
        });
    return info;
}


#pragma mark - Login
+(void)checkLoginStatus:(LoginCallback)result
{
    SZGlobalInfo * globalobjc = [SZGlobalInfo sharedManager];
    
    globalobjc.loginResult = result;
    
    SZUserInfo * newUserInfo = [[SZManager sharedManager].delegate onGetUserInfo];
    NSString * newUserId = newUserInfo.userid;
    NSString * localUserId = [SZGlobalInfo sharedManager].localAppUserId;
    
    //如果app已登录
    if (newUserId.length)
    {
        //本地有
        if (localUserId.length)
        {
            //两个TGT相同
            if ([newUserId isEqualToString:localUserId])
            {
                [SZGlobalInfo sharedManager].loginDesc = @"MJToken_APP已登录_融媒已登";
                if (result)
                {
                    result(YES);
                }
            }
            
            //TGT不同，则表示切换了用户
            else
            {
                [SZGlobalInfo sharedManager].loginDesc = @"MJToken_APP切换了用户_重登融媒";
                [SZGlobalInfo mjclearLoginInfo];
                [globalobjc requestToken:newUserInfo];
            }
        }
        
        //本地无TGT
        else
        {
            [SZGlobalInfo sharedManager].loginDesc = @"MJToken_APP已登录_登录融媒";
            [globalobjc requestToken:newUserInfo];
        }
    }
    else
    {
        //清理本地token和TGT
        [SZGlobalInfo sharedManager].loginDesc = @"MJToken_APP未登录_清空融媒登录信息";
        [SZGlobalInfo mjclearLoginInfo];
        
        if (result)
        {
            result(NO);
        }
    }
}




//读取登录数据
-(void)mjloadLocalData
{
    self.localAppUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"LOCAL_APP_USER_ID"];
    self.SZRMToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"SZRM_TOKEN"];
    self.GDYToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"SZRM_GDY_TOKEN"];
    self.SZRMUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"SZRM_USER_ID"];
    self.SZRMUserInfo = [[NSUserDefaults standardUserDefaults]valueForKey:@"SZRM_USER_INFO"];
}



//清除登录数据
+(void)mjclearLoginInfo
{
    SZGlobalInfo * instance = [SZGlobalInfo sharedManager];
    instance.SZRMToken = nil;
    instance.localAppUserId = nil;
    instance.GDYToken = nil;
    instance.SZRMUserId = nil;
    instance.SZRMUserInfo = nil;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LOCAL_APP_USER_ID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SZRM_TOKEN"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SZRM_GDY_TOKEN"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SZRM_USER_ID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SZRM_USER_INFO"];
}






#pragma mark - Request
-(void)requestToken:(SZUserInfo*)user
{
    TokenExchangeModel * requestModel = [TokenExchangeModel model];
    requestModel.isJSON = YES;
    
    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    
    [param setValue:[SZManager sharedManager].appid forKey:@"appId"];
    [param setValue:user.userid forKey:@"userId"];
    [param setValue:user.mobile forKey:@"mobile"];
    [param setValue:user.avatarUrl forKey:@"headProfile"];
    [param setValue:user.nickname forKey:@"nickName"];
    
    
    
    __weak typeof (self) weakSelf = self;
    [requestModel PostRequestInView:MJ_KEY_WINDOW WithUrl:APPEND_SUBURL(BASE_URL, API_URL_3rd_LOGIN) Params:param Success:^(id responseObject) {
            [weakSelf requestTokenDone:requestModel appUserId:user.userid];
        if (weakSelf.loginResult)
        {
            weakSelf.loginResult(YES);
        }
        } Error:^(id responseObject) {
            if (weakSelf.loginResult)
            {
                weakSelf.loginResult(NO);
            }
            
        } Fail:^(NSError *error) {
            if (weakSelf.loginResult)
            {
                weakSelf.loginResult(NO);
            }
        }];
}

-(void)requestTokenDone:(TokenExchangeModel*)model appUserId:(NSString*)appuserid
{
    //存对象
    self.SZRMToken = model.token;
    self.SZRMUserId = model.userInfo.id;
    self.GDYToken = model.gdyToken;
    self.localAppUserId = appuserid;
    self.SZRMUserInfo = [model yy_modelToJSONString];
    
    
    
    //存本地
    [[NSUserDefaults standardUserDefaults]setValue:self.SZRMToken forKey:@"SZRM_TOKEN"];
    [[NSUserDefaults standardUserDefaults]setValue:self.GDYToken forKey:@"SZRM_GDY_TOKEN"];
    [[NSUserDefaults standardUserDefaults]setValue:self.SZRMUserId forKey:@"SZRM_USER_ID"];
    [[NSUserDefaults standardUserDefaults]setValue:self.localAppUserId forKey:@"LOCAL_APP_USER_ID"];
    [[NSUserDefaults standardUserDefaults]setValue:self.SZRMUserInfo forKey:@"SZRM_USER_INFO"];
    
    
    //发广播
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SZRMTokenExchangeDone" object:nil];
}


#pragma mark - Other
//获取baseURL
+(NSString *)mjgetBaseURL
{
    SZManager * instance = [SZManager sharedManager];
    if (instance.enviroment==UAT_ENVIROMENT)
    {
        return @"https://uat-fuse-api-gw.zhcs.csbtv.com";
    }
    else
    {
        return @"https://fuse-api-gw.zhcs.csbtv.com";
    }
}


//获取H5地址
+(NSString*)mjgetBaseH5URL
{
    SZManager * instance = [SZManager sharedManager];
    if (instance.enviroment==UAT_ENVIROMENT)
    {
        return @"https://uat-h5.zhcs.csbtv.com";
    }
    else
    {
        return @"https://h5.zhcs.csbtv.com";
    }
}






//分享
+(void)mjshareToPlatform:(SZ_SHARE_PLATFORM)platform content:(ContentModel*)contentM source:(NSString*)source
{
    if ([SZGlobalInfo checkDelegate])
    {
        [[SZManager sharedManager].delegate onShareAction:platform title:contentM.shareTitle image:contentM.shareImageUrl desc:contentM.shareBrief URL:contentM.shareUrl];
        
        //行为埋点
        NSMutableDictionary * param=[NSMutableDictionary dictionary];
        [param setValue:contentM.id forKey:@"content_id"];
        [param setValue:contentM.title forKey:@"content_name"];
        [param setValue:contentM.source forKey:@"content_source"];
        [param setValue:contentM.thirdPartyId forKey:@"third_ID"];
        [param setValue:contentM.keywords forKey:@"content_key"];
        [param setValue:contentM.tags forKey:@"content_list"];
        [param setValue:contentM.classification forKey:@"content_classify"];
        [param setValue:contentM.startTime forKey:@"create_time"];
        [param setValue:contentM.issueTimeStamp forKey:@"publish_time"];
        [param setValue:contentM.type forKey:@"content_type"];
        [param setValue:source forKey:@"transmit_location"];
        
        [SZUserTracker trackingButtonEventName:@"content_transmit" param:param];
    }
    
}


//跳转到登录页
+(void)mjgoToLoginPage
{
    [[SZManager sharedManager].delegate onLoginAction];
}


//弹出登录提示
+(void)mjshowLoginAlert
{
    [MJHUD_Alert showLoginAlert:^(id objc) {
        [MJHUD_Alert hideAlertView];
        [SZGlobalInfo mjgoToLoginPage];
    }];
}



#pragma mark - Check
+(BOOL)checkDelegate
{
    id delegate = [SZManager sharedManager].delegate;
    if (delegate && [delegate respondsToSelector:@selector(onShareAction:title:image:desc:URL:)])
    {
        return YES;;
    }
    else
    {
        NSLog(@"请实现SZDelegate方法");
        return NO;;
    }
}

@end
