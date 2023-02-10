//
//  SZThirdAppInfo.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "SZThirdAppInfo.h"
#import "NSObject+MJCategory.h"
#import "YYModel.h"

@implementation SZThirdAppInfo

-(void)parseData:(id)data
{
    [self yy_modelSetWithDictionary:data];
    
    NSDictionary * dic = [data mj_valueForKey:@"config"];
    
    SZThirdAppConfig * configModel = [[SZThirdAppConfig alloc]init];
    [configModel yy_modelSetWithDictionary:dic];
    
    self.config = configModel;
}


@end
