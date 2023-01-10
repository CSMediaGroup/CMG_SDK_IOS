//
//  SZUserInfoModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/30.
//

#import "SZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZUserInfoModel : SZBaseModel

@property(strong,nonatomic)NSString * id;
@property(strong,nonatomic)NSString * tenantId;
@property(strong,nonatomic)NSString * orgId;
@property(strong,nonatomic)NSString * orgName;
@property(strong,nonatomic)NSString * nickname;
@property(strong,nonatomic)NSString * username;

@property(strong,nonatomic)NSString * cardName;
@property(strong,nonatomic)NSString * head;

@property(strong,nonatomic)NSString * state;
@property(strong,nonatomic)NSString * gender;

@property(strong,nonatomic)NSString * enableRecommend;
@property(strong,nonatomic)NSString * permissionCodes;
@property(strong,nonatomic)NSString * phone;
@property(strong,nonatomic)NSString * cardNo;

@end

NS_ASSUME_NONNULL_END
