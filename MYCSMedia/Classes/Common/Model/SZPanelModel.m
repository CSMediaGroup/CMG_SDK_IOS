//
//  SZPanelModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/23.
//

#import "SZPanelModel.h"
#import "NSObject+MJCategory.h"
#import "NSObject+YYModel.h"
#import "SZPanelConfigModel.h"
#import "SZContentModel.h"
#import "SZCategoryModel.h"


@implementation SZPanelModel

-(void)parseData:(id)data
{
    //其他属性
    [self modelSetWithDictionary:data];
    
    //config
    SZPanelConfigModel * configModel = [SZPanelConfigModel model];
    NSDictionary * configdic = [data mj_valueForKey:@"config"];
    [configModel parseData:configdic];
    self.config = configModel;
    
    //contents
    NSArray * contents = [data mj_valueForKey:@"contents"];
    for (int i = 0; i<contents.count; i++)
    {
        NSDictionary * contentDic = contents[i];
        SZContentModel * model = [SZContentModel model];
        [model modelSetWithDictionary:contentDic];
        [self.dataArr addObject:model];
    }
    
    //subcategories
    NSArray * subarr = [data mj_valueForKey:@"subCategories"];
    NSMutableArray * subcate = [NSMutableArray array];
    self.subCategories = subcate;
    for (int i = 0; i<subarr.count; i++)
    {
        NSDictionary * subcateDic = subarr[i];
        
        SZCategoryModel * submodel = [SZCategoryModel model];
        [submodel modelSetWithDictionary:subcateDic];
        [self.subCategories addObject:submodel];
    }
}

@end

