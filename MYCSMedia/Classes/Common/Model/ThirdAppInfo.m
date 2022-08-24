//
//  ThirdAppInfo.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "ThirdAppInfo.h"
#import "NSObject+MJCategory.h"
#import "YYKit.h"

@implementation ThirdAppInfo

-(void)parseData:(id)data
{
    [self modelSetWithDictionary:data];
    
    NSDictionary * dic = [data mj_valueForKey:@"config"];
    
    ThirdAppConfig * configModel = [[ThirdAppConfig alloc]init];
    [configModel modelSetWithDictionary:dic];
    
    self.config = configModel;
}


@end
