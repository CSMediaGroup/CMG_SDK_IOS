//
//  MJBridgeHandler.h
//  智慧长沙
//
//  Created by 马佳 on 2020/2/14.
//  Copyright © 2020 ChangShaBroadcastGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJWKWebViewJavascriptBridge.h"

#import "MJWebview.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJBridgeHandler : NSObject

+(void)handleJSBridge:(id)data callBack:(MJJBResponseCallback)responseCallback sender:(MJWebview*)web;

@end

NS_ASSUME_NONNULL_END
