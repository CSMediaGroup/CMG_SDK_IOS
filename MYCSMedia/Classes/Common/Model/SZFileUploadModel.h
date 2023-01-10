//
//  SZFileUploadModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/27.
//

#import "SZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZFileUploadModel : SZBaseModel

@property(strong,nonatomic)NSString * coverImageUrl;
@property(strong,nonatomic)NSString * url;
@property(strong,nonatomic)NSNumber * width;
@property(strong,nonatomic)NSNumber * height;
@property(strong,nonatomic)NSNumber * duration;
@property(strong,nonatomic)NSString * orientation;
@property(strong,nonatomic)NSNumber * size;

@end

NS_ASSUME_NONNULL_END
