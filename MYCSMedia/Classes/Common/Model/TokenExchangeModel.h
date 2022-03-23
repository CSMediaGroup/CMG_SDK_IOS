//
//  TokenExchangeModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/11.
//

#import "BaseModel.h"
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenExchangeModel : BaseModel
@property(strong,nonatomic)NSString * token;
@property(strong,nonatomic)NSString * gdyToken;
@property(strong,nonatomic)NSString * mycsUserId;
@property(strong,nonatomic)UserInfoModel * loginSysUserVo;
@property(strong,nonatomic)NSString * certificated;
@property(strong,nonatomic)NSString * asideCode;
@property(strong,nonatomic)NSString * thirdPartyUserId;
@property(strong,nonatomic)NSString * appId;


@end

NS_ASSUME_NONNULL_END
