//
//  SZThirdAppInfo.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "SZThirdAppInfo.h"
#import "NSObject+MJCategory.h"
#import "YYKit.h"

@implementation SZThirdAppInfo

-(void)parseData:(id)data
{
    [self modelSetWithDictionary:data];
    
    NSDictionary * dic = [data mj_valueForKey:@"config"];
    
    SZThirdAppConfig * configModel = [[SZThirdAppConfig alloc]init];
    [configModel modelSetWithDictionary:dic];
    
    self.config = configModel;
}


@end
