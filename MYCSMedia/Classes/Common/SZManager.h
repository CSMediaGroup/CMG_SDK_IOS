//
//  SZManager.h
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/28.
//

#import <Foundation/Foundation.h>
#import "SZUserInfo.h"

//分享平台
typedef NS_ENUM(NSUInteger, SZ_SHARE_PLATFORM)
{
    WECHAT_PLATFORM = 0,
    TIMELINE_PLATFORM,
    QQ_PLATFORM
};

//环境
typedef NS_ENUM(NSUInteger, SZ_ENV)
{
    UAT_ENVIROMENT = 0,
    PRD_ENVIROMENT,
};





@protocol SZDelegate <NSObject>
//获取用户信息
-(SZUserInfo*)onGetUserInfo;
//分享事件
-(void)onShareAction:(SZ_SHARE_PLATFORM)platform title:(NSString*)title image:(NSString*)imgurl desc:(NSString*)desc URL:(NSString*)url;
//跳转到登录页
-(void)onLoginAction;
@end




@interface SZManager : NSObject
@property(assign,nonatomic)SZ_ENV enviroment;
@property(weak,nonatomic)id <SZDelegate> delegate;
@property(strong,nonatomic)NSString * appid;
@property(strong,nonatomic)NSString * appkey;

+(SZManager*)sharedManager;
+(void)initWithAppId:(NSString*)appid appKey:(NSString*)appkey appDelegate:(id<SZDelegate>)delegate enviroment:(SZ_ENV)env;

@end





