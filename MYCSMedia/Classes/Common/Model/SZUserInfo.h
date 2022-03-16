//
//  SZUserInfo.h
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZUserInfo : NSObject
@property(strong,nonatomic)NSString * userid;
@property(strong,nonatomic)NSString * mobile;
@property(strong,nonatomic)NSString * avatarUrl;
@property(strong,nonatomic)NSString * nickname;
@end

NS_ASSUME_NONNULL_END
