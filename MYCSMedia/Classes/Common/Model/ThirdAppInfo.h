//
//  ThirdAppInfo.h
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/17.
//

#import "BaseModel.h"
#import "ThirdAppConfig.h"



@interface ThirdAppInfo : BaseModel

@property(strong,nonatomic)NSString * id;
@property(strong,nonatomic)NSString * logo;
@property(strong,nonatomic)ThirdAppConfig * config;

@end

