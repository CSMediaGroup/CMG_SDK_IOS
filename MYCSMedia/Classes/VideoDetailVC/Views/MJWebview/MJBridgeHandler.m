//
//  MJBridgeHandler.m
//  智慧长沙
//
//  Created by 马佳 on 2020/2/14.
//  Copyright © 2020 ChangShaBroadcastGroup. All rights reserved.
//

#import "MJBridgeHandler.h"
#import "NSObject+MJCategory.h"
#import "UIDevice+MJCategory.h"
#import "SZManager.h"
#import "SZGlobalInfo.h"
#import "YYModel.h"
#import "SDWebImage.h"
#import <Photos/Photos.h>
#import "UIResponder+MJCategory.h"
#import "SZVideoDetailVC.h"
#import "SZWebVC.h"


@implementation MJBridgeHandler

+(void)handleJSBridge:(id)data callBack:(WVJBResponseCallback)callBack sender:(nonnull MJWebview *)web
{
    
    NSString * keyName =  [data mj_valueForKey:@"methodName"];
    id objc = [data mj_valueForKey:@"data"];
    
    NSLog(@"JS-Call:\n%@",data);
    
    //设置标题
    if ([keyName isEqualToString:@"setTitle"])
    {
        [web setWebviewTitle:objc];
    }
    
    //返回
    else if ([keyName isEqualToString:@"monitorLifeCycle"])
    {
        [web webviewBackAction];
    }
    
    //获取设备ID
    else if ([keyName isEqualToString:@"getDeviceId"])
    {
        if (callBack)
        {
            NSString * deviceId = [UIDevice getIDFA];
            NSDictionary * dic = @{@"deviceId":deviceId};
            callBack(dic);
        }
    }
    
    //获取用户信息
    else if ([keyName isEqualToString:@"getUserInfo"])
    {
        if (callBack)
        {
            SZGlobalInfo * global = [SZGlobalInfo sharedManager];
            NSString * json = global.SZRMUserInfo;
            
            callBack(json);
        }
    }
    
    //分享
    else if ([keyName isEqualToString:@"share"])
    {
        NSDictionary * dic = [data mj_valueForKey:@"data"];
        
        NSString * platform = [dic mj_valueForKey:@"platform"];
        NSString * shareUrl = [dic mj_valueForKey:@"shareUrl"];
        NSString * shareImage = [dic mj_valueForKey:@"shareImage"];
        NSString * shareTitle = [dic mj_valueForKey:@"shareTitle"];
        NSString * shareBrief = [dic mj_valueForKey:@"shareBrief"];
        
        [[SZManager sharedManager].delegate onShareAction:platform.intValue title:shareTitle image:shareImage desc:shareBrief URL:shareUrl];
    }
    
    //保存图片
    else if ([keyName isEqualToString:@"savePhoto"])
    {
        NSString * img = [objc mj_valueForKey:@"url"];
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:img] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (finished)
                    {
                        UIImage * imgsave = image;
                        
                        NSString * path = NSHomeDirectory();
                        //图片存储的沙盒路径
                        NSString * Pathimg = [path stringByAppendingString:@"/Documents/test.png"];
                        [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
                        
                        //使用url存储到相册
                        NSURL *imagePathUrl = [NSURL fileURLWithPath:Pathimg];
                        
                        //查询相册权限
                        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                            if (status == PHAuthorizationStatusAuthorized)
                            {
                                //权限判断
                                PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
                                [library performChanges:^{
                                    [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imagePathUrl];
                                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                                    if (success)
                                    {
                                        NSLog(@"保存成功");
                                        
                                        
                                        if(callBack)
                                        {
                                            callBack(@1);
                                        }
                                        
                                    }
                                    else
                                    {
                                        callBack(@0);
                                    }
                                }];
                            }
                        }];
                    }
        }];
        
    }
    
    
    
    //打开webview
    else if ([keyName isEqualToString:@"jumpToNativePage"])
    {
        SZWebVC * vc = [[SZWebVC alloc]init];
        vc.H5URL = [objc mj_valueForKey:@"newsLink"];
        
        vc.shareTitle = [objc mj_valueForKey:@"title"];
        vc.shareUrl = [objc mj_valueForKey:@"link"];
        vc.shareBrief = [objc mj_valueForKey:@"content"];
        vc.shareImg = [objc mj_valueForKey:@"imgUrl"];
        
        
        
        [[web getCurrentNavigationController]pushViewController:vc animated:YES];
    }
    
    
    
    //打开登录页
    else if ([keyName isEqualToString:@"goLogin"])
    {
        [[SZManager sharedManager].delegate onLoginAction];
    }
    
    
    //打开视频详情
    else if ([keyName isEqualToString:@"openVideo"])
    {
        
        NSString * contentId = [objc mj_valueForKey:@"contentId"];
        SZVideoDetailVC * vc =[[SZVideoDetailVC alloc]init];
        vc.contentId = contentId;
        vc.detailType = 0;
        [[web getCurrentNavigationController]pushViewController:vc animated:YES];
    }
    
    
    //测试
    else if ([keyName isEqualToString:@"mjtest"])
    {
        if (callBack)
        {
            SZUserInfo * user = [[SZUserInfo alloc]init];
            user.userid=@"1111";
            user.avatarUrl=@"xx.png";
            callBack(user);
        }
    }
    
    
    
    

}



@end
