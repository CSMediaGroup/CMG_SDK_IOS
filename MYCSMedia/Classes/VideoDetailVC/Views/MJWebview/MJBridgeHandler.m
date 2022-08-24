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
#import "SDWebImage.h"
#import <Photos/Photos.h>
#import "UIResponder+MJCategory.h"
#import "SZVideoDetailVC.h"
#import "SZWebVC.h"
#import "MJHUD_Selection.h"
#import "YYKit.h"

@implementation MJBridgeHandler

+(void)handleJSBridge:(id)data callBack:(WVJBResponseCallback)callBack sender:(nonnull MJWebview *)web
{
    
    NSString * keyName =  [data mj_valueForKey:@"methodName"];
    id objc = [data mj_valueForKey:@"data"];
    
    //设置标题
    if ([keyName isEqualToString:@"setTitle"])
    {
        NSString * titlestr = [objc mj_valueForKey:@"title"];
        [web setWebviewTitle:titlestr];
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
            NSString * json = [dic  modelToJSONString];
            callBack(json);
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
        
        NSString * shareTitle = [dic mj_valueForKey:@"title"];
        NSString * shareUrl = [dic mj_valueForKey:@"link"];
        NSString * shareBrief = [dic mj_valueForKey:@"content"];
        NSString * shareImg = [dic mj_valueForKey:@"imgUrl"];
        
        
        ContentModel * content = [ContentModel model];
        content.shareUrl = shareUrl;
        content.shareBrief = shareBrief;
        content.shareTitle = shareTitle;
        content.shareImageUrl = shareImg;
        
        [MJHUD_Selection showShareView:^(id objc) {
            NSNumber * number = objc;
            SZ_SHARE_PLATFORM plat = number.integerValue;

            [SZGlobalInfo mjshareToPlatform:plat content:content source:@"底部分享"];
        }];
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
                                        if(callBack)
                                        {
                                            callBack(@"1");
                                        }
                                        
                                    }
                                    else
                                    {
                                        callBack(@"0");
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
    
    
    
    //获取设备信息
    else if ([keyName isEqualToString:@"getAppVersion"])
    {
        NSMutableDictionary * param=[NSMutableDictionary dictionary];
    
        NSString * appVer = [UIDevice getAppVersion];
        NSString * osVer = [UIDevice getSystemVersion];
        
        
        [param setValue:appVer forKey:@"appVersion"];
        [param setValue:osVer forKey:@"osVersion"];
        [param setValue:@"apple" forKey:@"brand"];
        [param setValue:@"ios" forKey:@"osName"];
        
        NSString * json = [param  modelToJSONString];
        
        if (callBack)
        {
            callBack(json);
        }
    }
    
    
    
    else
    {
        
    }
    
    
    

}



@end
