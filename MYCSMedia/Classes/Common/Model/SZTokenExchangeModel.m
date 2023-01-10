//
//  SZTokenExchangeModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/11.
//

#import "SZTokenExchangeModel.h"
#import "NSObject+YYModel.h"
#import "SZUserInfoModel.h"


@implementation SZTokenExchangeModel
-(void)parseData:(id)data
{
    [self modelSetWithDictionary:data];
    
    NSDictionary * userDic = [data valueForKey:@"loginSysUserVo"];
    SZUserInfoModel * userModel = [SZUserInfoModel model];
    [userModel parseData:userDic];
    self.loginSysUserVo = userModel;
    
}

@end
