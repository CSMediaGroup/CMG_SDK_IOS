//
//  ThirdAppInfo.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "ThirdAppInfo.h"
#import "YYModel.h"
#import "NSObject+MJCategory.h"

@implementation ThirdAppInfo

-(void)parseData:(id)data
{
    [self yy_modelSetWithDictionary:data];
    
    NSDictionary * dic = [data mj_valueForKey:@"config"];
    
    ThirdAppConfig * configModel = [[ThirdAppConfig alloc]init];
    [configModel yy_modelSetWithDictionary:dic];
    
    self.config = configModel;
}


@end
