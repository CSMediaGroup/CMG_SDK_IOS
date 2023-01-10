//
//  MJWebview.m
//  智慧长沙
//
//  Created by 马佳 on 2020/1/2.
//  Copyright © 2020 ChangShaBroadcastGroup. All rights reserved.
//

#import "MJWebview.h"
#import <WebKit/WebKit.h>
#import "MJBridgeHandler.h"
#import "UIView+MJCategory.h"
#import "SZDefines.h"
#import "NSString+MJCategory.h"
#import "MJHUD.h"
#import "UIResponder+MJCategory.h"
#import "SZGlobalInfo.h"
#import "WKWebViewJavascriptBridge.h"
#import "UIDevice+MJCategory.h"
#import "SZThirdAppInfo.h"
#import "YYKit.h"

@interface MJWebview ()<WKUIDelegate,WKNavigationDelegate>
@property(strong,nonatomic)WKWebViewJavascriptBridge * mjbridge;
@end

@implementation MJWebview
{
    CGFloat loadingPercent;
    WKWebView * webview;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //Config
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.allowsInlineMediaPlayback=YES;
        if (@available(iOS 10.0, *))
        {
            config.mediaTypesRequiringUserActionForPlayback=NO;
        }
        
        
        //需要注入的东西

        //1.userInfo
        SZGlobalInfo * global = [SZGlobalInfo sharedManager];
        NSString * injectStr1 = [NSString stringWithFormat:@"window.userInfo='%@'",global.SZRMUserInfo];

        //2.deviceId
        NSString * deviceId = [UIDevice getIDFA];
        NSDictionary * dic2 = @{@"deviceId":deviceId};
        NSString * injectStr2 = [NSString stringWithFormat:@"window.deviceId='%@'",[dic2 modelToJSONString]];

        //3.appVersion
        NSMutableDictionary * dic3=[NSMutableDictionary dictionary];
        NSString * appVer = [UIDevice getAppVersion];
        NSString * osVer = [UIDevice getSystemVersion];
        [dic3 setValue:appVer forKey:@"appVersion"];
        [dic3 setValue:osVer forKey:@"osVersion"];
        [dic3 setValue:@"apple" forKey:@"brand"];
        [dic3 setValue:@"ios" forKey:@"osName"];
        NSString * injectStr3 = [NSString stringWithFormat:@"window.appVersion='%@'",[dic3 modelToJSONString]];

        //4.orgInfo
        NSString * orgStr = [global.thirdApp modelToJSONString];
        NSString * injectStr4 = [NSString stringWithFormat:@"window.orgInfo='%@'",orgStr];



        //创建WKUserScript
        WKUserScript *jqueryScript = [[WKUserScript alloc]initWithSource:injectStr1 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
       [config.userContentController addUserScript:jqueryScript];

        WKUserScript *jqueryScript2 = [[WKUserScript alloc]initWithSource:injectStr2 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
       [config.userContentController addUserScript:jqueryScript2];

        WKUserScript *jqueryScript3 = [[WKUserScript alloc]initWithSource:injectStr3 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
       [config.userContentController addUserScript:jqueryScript3];

        WKUserScript *jqueryScript4 = [[WKUserScript alloc]initWithSource:injectStr4 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
       [config.userContentController addUserScript:jqueryScript4];

        
        //WKWebview
        webview = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,self.width,self.height) configuration:config];
        webview.backgroundColor=[UIColor whiteColor];
        webview.scrollView.bounces=NO;
        webview.scrollView.showsVerticalScrollIndicator=NO;
        webview.UIDelegate=self;
        webview.navigationDelegate=self;
        [self addSubview:webview];
        
        
        //WebviewJavaScriptBridge
        __weak typeof (self) weakSelf = self;
        _mjbridge = [WKWebViewJavascriptBridge bridgeForWebView:webview];
        [_mjbridge registerHandler:@"MJBrigeHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
            [MJBridgeHandler handleJSBridge:data callBack:responseCallback sender:weakSelf];
           }];
        [_mjbridge setWebViewDelegate:weakSelf];
        
        
        //添加监听
        [self addObservers];
    }
    return self;
}


-(void)dealloc
{
    [self removeObservers];
    
    MJLOG(@"MJWebview_dealloc");
}


#pragma mark - Subview
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [webview setFrame:CGRectMake(0, 0, self.width, self.height)];
}


#pragma mark - 添加/删除JS监听
-(void)addObservers
{
    //登陆成功事件广播
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:@"SZRMTokenExchangeDone" object:nil];
    
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)removeObservers
{
    [_mjbridge removeHandler:@"MJBrigeHandler"];
    
    [self stopAllMedia];

    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [webview removeObserver:self forKeyPath:@"title"];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //进度条
    if (object == webview && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        loadingPercent = newprogress;
        if (newprogress==1.0)
        {
            
        }
    }
    
    //标题
    else if (object == webview && [keyPath isEqualToString:@"title"])
    {
        NSString * titleStr = [change objectForKey:NSKeyValueChangeNewKey];
        if (self.mjwebviewDelegate && [self.mjwebviewDelegate respondsToSelector:@selector(mjWebview:passValue:forKey:)])
        {
            [self.mjwebviewDelegate mjWebview:self passValue:titleStr forKey:@"webTitle"];
        }
    }
    
    //尺寸
    else if (object == webview.scrollView && [keyPath isEqualToString:@"contentSize"])
    {
        static CGFloat height = 0;
        if (height==0)
        {
            height=webview.height;
        }
        
        if (webview.scrollView.contentSize.height!=height)
        {
            height = webview.scrollView.contentSize.height;
            
            if (self.mjwebviewDelegate && [self.mjwebviewDelegate respondsToSelector:@selector(didUpdateWebviewContentHeight:)])
            {
                [self.mjwebviewDelegate didUpdateWebviewContentHeight:height];
            }
            
        }
    }
}



#pragma mark - 外部API
-(void)startLoadURL
{
    if (self.customURL)
    {
        NSURLRequestCachePolicy H5Policy = NSURLRequestUseProtocolCachePolicy;
        if (DEV_ENV)
        {
            H5Policy = NSURLRequestReloadIgnoringCacheData;
        }
        
        NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:self.customURL cachePolicy:H5Policy timeoutInterval:15];
        [webview loadRequest:req];
    }
    else
    {
        NSURL * url = nil;
        
        //打印调试
        MJLOG(@"MJWebview_Start_Loading = %@",_H5URL);
        
        //生成URL
        url = [NSURL URLWithString:_H5URL];
        
        
        if(_H5URL.length==0)
        {
            _H5URL=@"about blank";
            
        }
        else if (url==nil)
        {
            
        }
        else
        {
            if (!self.customLoading)
            {
                
            }
            
            NSURLRequestCachePolicy H5Policy = NSURLRequestUseProtocolCachePolicy;
            if (DEV_ENV)
            {
                H5Policy = NSURLRequestReloadIgnoringCacheData;
            }
            
            NSURLRequest * req = [NSURLRequest requestWithURL:url cachePolicy:H5Policy timeoutInterval:15];
            [webview loadRequest:req];
        }
    }
    
   
}


//停止播放
-(void)stopAllMedia
{
    [self MJRunJavaScript:@"videoPause('')"];
}


//历史记录
-(void)webviewBackAction
{
    [self.mjwebviewDelegate mjWebview:self passValue:nil forKey:@"webback"];
}

//设置标题
-(void)setWebviewTitle:(NSString *)title
{
    [self.mjwebviewDelegate mjWebview:self passValue:title forKey:@"webTitle"];
}

//外部调用JS
-(void)MJRunJavaScript:(NSString*)script
{
    [webview evaluateJavaScript:script completionHandler:nil];
}

//外部调用JS Brdige 注册的方法
-(void)callJSBrdigeMethod:(NSString*)method data:(id)data callback:(JSCallBack)blk
{
    [self.mjbridge callHandler:method data:data responseCallback:blk];
}



#pragma mark - 拦截URL
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    _H5URL = navigationAction.request.URL.absoluteString;
    NSString * reqStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    //打开app
    if ([reqStr hasPrefix:@"wbmain://"])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    //电话
    else if ([reqStr hasPrefix:@"tel:"])
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:reqStr];
        [application openURL:URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}




#pragma mark - 登录成功
-(void)loginSuccess:(NSNotification*)noty
{
    NSString * szrmToken = [SZGlobalInfo sharedManager].SZRMUserInfo;
    NSString * str = [NSString stringWithFormat:@"onAppLogin('%@')",szrmToken];
    [self MJRunJavaScript:str];
}



#pragma mark - UI Delegate
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}



#pragma mark - WKWebView Delegate
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    [MJHUD_Alert showAlertViewWithTitle:@"提示" text:message sure:^(id objc) {
        [MJHUD_Alert hideAlertView];
    }];
    

    completionHandler();
}
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     completionHandler(NO);
                                 }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     completionHandler(YES);
                                 }])];
    
    [[self getCurrentNavigationController]presentViewController:alertController animated:YES completion:nil];
}
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         textField.text = defaultText;
     }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     completionHandler(alertController.textFields[0].text?:@"");
                                 }])];
    
    [[self getCurrentNavigationController]presentViewController:alertController animated:YES completion:nil];
}

@end
