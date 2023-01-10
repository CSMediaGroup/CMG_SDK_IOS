//
//  SZTokenExchangeModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/11.
//

#import "SZBaseModel.h"
#import "SZUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZTokenExchangeModel : SZBaseModel
@property(strong,nonatomic)NSString * token;
@property(strong,nonatomic)NSString * gdyToken;
@property(strong,nonatomic)NSString * mycsUserId;
@property(strong,nonatomic)SZUserInfoModel * loginSysUserVo;
@property(strong,nonatomic)NSString * certificated;
@property(strong,nonatomic)NSString * asideCode;
@property(strong,nonatomic)NSString * thirdPartyUserId;
@property(strong,nonatomic)NSString * appId;


@end

NS_ASSUME_NONNULL_END
