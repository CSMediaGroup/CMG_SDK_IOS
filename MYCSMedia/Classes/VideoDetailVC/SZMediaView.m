//
//  SZMediaView.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/7/4.
//

#import "SZMediaView.h"
#import "SZDefines.h"
#import "MJWebview.h"
#import "Masonry.h"
#import "UIView+MJCategory.h"
#import "ThirdAppInfo.h"
#import "SZGlobalInfo.h"

@implementation SZMediaView
{
    MJWebview * web;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadAppInfo];
        
        [SZGlobalInfo checkLoginStatus:nil];
    }
    return self;
}

-(void)loadAppInfo
{
    ThirdAppInfo * info = [SZGlobalInfo sharedManager].thirdApp;
    
    if (info.config.listUrl.length)
    {
        web = [[MJWebview alloc]init];
        [self addSubview:web];
        [web mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        web.H5URL = info.config.listUrl;
        [web startLoadURL];
    }
    else
    {
        static int count = 0;
        count++;
        if (count<=5)
        {
            NSLog(@"retry");
            [self performSelector:@selector(loadAppInfo) withObject:nil afterDelay:0.2];
        }
        
    }
    
}

@end
