//
//  SZVideoRelateModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/5.
//

#import "SZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZVideoRelateModel : SZBaseModel
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,copy) NSString *externalUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber *isExternal;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *thumbnailUrl;
@property (nonatomic,copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
