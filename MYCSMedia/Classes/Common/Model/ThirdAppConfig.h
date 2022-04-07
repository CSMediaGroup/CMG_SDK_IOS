//
//  ThirdAppConfig.h
//  MYCSMedia
//
//  Created by 马佳 on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdAppConfig : NSObject
@property(strong,nonatomic)NSString * listUrl;
@property(strong,nonatomic)NSString * categoryCode;
@property(strong,nonatomic)NSString * detailUrl;
@property(strong,nonatomic)NSString * appName;
@property(strong,nonatomic)NSString * appKey;
@property(strong,nonatomic)NSString * recommendScene;
@property(strong,nonatomic)NSString * sourceName;
@property(strong,nonatomic)NSString * toVolcengine;

@end

NS_ASSUME_NONNULL_END
