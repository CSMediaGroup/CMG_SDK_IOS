//
//  SZPanelModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/23.
//

#import "SZBaseModel.h"
#import "SZPanelConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZPanelModel : SZBaseModel


@property (nonatomic,strong) NSString *id;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *typeName;
@property (nonatomic,copy) NSString *typeCode;
@property (nonatomic,copy) NSString *limitCount;
@property (nonatomic,strong) NSNumber *categoryId;
@property (nonatomic,strong) NSNumber *isCategoryPanel;


@property (nonatomic,strong) NSMutableArray * subCategories;

@property (nonatomic,strong) SZPanelConfigModel * config;
@end

NS_ASSUME_NONNULL_END
