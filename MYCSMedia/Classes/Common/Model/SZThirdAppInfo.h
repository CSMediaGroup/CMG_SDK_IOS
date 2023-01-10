//
//  SZThirdAppInfo.h
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "SZBaseModel.h"
#import "SZThirdAppConfig.h"



@interface SZThirdAppInfo : SZBaseModel

@property(strong,nonatomic)NSString * id;
@property(strong,nonatomic)NSString * logo;
@property(strong,nonatomic)SZThirdAppConfig * config;

@end

