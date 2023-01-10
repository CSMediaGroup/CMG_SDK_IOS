//
//  SZManager.h
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/28.
//

#import <Foundation/Foundation.h>
#import "SZUserInfo.h"
#import "SZContentModel.h"

//分享平台
typedef NS_ENUM(NSUInteger, SZ_SHARE_PLATFORM)
{
    WECHAT_PLATFORM = 0,
    TIMELINE_PLATFORM,
    QQ_PLATFORM
};

//生产环境
typedef NS_ENUM(NSUInteger, SZ_ENV)
{
    UAT_ENVIROMENT = 0,
    PRD_ENVIROMENT,
};

typedef void (^RMSuccessBlock)(NSArray<SZContentModel*>* data);
typedef void (^RMErrorBlock)(NSString * msg);
typedef void (^RMFailBlock)(NSError * error);



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

//获取单例
+(SZManager*)sharedManager;

//初始化SDK
+(void)initWithAppId:(NSString*)appid appKey:(NSString*)appkey appDelegate:(id<SZDelegate>)delegate enviroment:(SZ_ENV)env;

//获取列表数据
+(void)requestContentList:(NSInteger)pagesize Success:(RMSuccessBlock)successblock Error:(RMErrorBlock)errorblock Fail:(RMFailBlock)failblock;

//进入新闻详情页
+(void)routeToDetailPage:(UINavigationController*)nav content:(SZContentModel*)data;

@end





