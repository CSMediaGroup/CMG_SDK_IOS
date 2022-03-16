//
//  MJWebview.h
//  智慧长沙
//
//  Created by 马佳 on 2020/1/2.
//  Copyright © 2020 ChangShaBroadcastGroup. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^JSCallBack)(id responseData);

@protocol MJWebviewDelegate <NSObject>
@optional
-(void)mjWebview:(UIView*)view passValue:(id)value forKey:(NSString*)key;
-(void)didUpdateWebviewContentHeight:(CGFloat)height;
@end



@interface MJWebview : UIView

@property(strong,nonatomic)NSURL * customURL;
@property(strong,nonatomic)NSString * H5URL;
@property(weak,nonatomic)id<MJWebviewDelegate> mjwebviewDelegate;
@property(assign,nonatomic)BOOL customLoading;



-(void)startLoadURL;
-(void)MJRunJavaScript:(NSString*)script;
-(void)callJSBrdigeMethod:(NSString*)method data:(id)data callback:(JSCallBack)blk;
-(void)webviewBackAction;
-(void)setWebviewTitle:(NSString*)title;

@end
