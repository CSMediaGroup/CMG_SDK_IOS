//
//  SZMediaVC.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/10.
//

#import "SZMediaVC.h"
#import "SZGlobalInfo.h"
#import "ThirdAppInfo.h"

@interface SZMediaVC ()

@end

@implementation SZMediaVC

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        ThirdAppInfo * info = [SZGlobalInfo sharedManager].thirdApp;
        self.H5URL = info.config.listUrl;
    }
    return self;
}


@end
