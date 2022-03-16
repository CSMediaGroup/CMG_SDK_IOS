//
//  SZMediaVC.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/10.
//

#import "SZMediaVC.h"

@interface SZMediaVC ()

@end

@implementation SZMediaVC

-(instancetype)init
{
    self = [super init];
    if (self)
    {
//        self.H5URL = @"https://uat-h5.zhcs.csbtv.com/sdk/news/#/";
        
        self.H5URL = @"http://192.168.31.161:8081/news/index.html#/";
    }
    return self;
}



@end
