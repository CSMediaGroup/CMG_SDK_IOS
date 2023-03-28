//
//  SZWebVC.h
//  智慧长沙
//
//  Created by 马佳 on 2019/10/21.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJWebview.h"


NS_ASSUME_NONNULL_BEGIN

@interface SZWebVC : UIViewController

@property(strong,nonatomic)NSURL * targetURL;
@property(strong,nonatomic)NSString * H5URL;
@property(strong,nonatomic)NSString * navTitle;

@property(strong,nonatomic)MJWebview * webview;

//param
@property(strong,nonatomic)NSString * contentId;
@property(strong,nonatomic)NSString * disableComment;
@property(strong,nonatomic)NSString * shareUrl;
@property(strong,nonatomic)NSString * shareImg;
@property(strong,nonatomic)NSString * shareTitle;
@property(strong,nonatomic)NSString * shareBrief;

@end

NS_ASSUME_NONNULL_END

