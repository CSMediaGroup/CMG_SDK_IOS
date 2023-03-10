//
//  SZCategoryListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/1/12.
//

#import "SZCategoryListModel.h"
#import "SZCategoryModel.h"
#import "NSObject+MJCategory.h"
#import <YYModel/YYModel.h>

@implementation SZCategoryListModel

-(void)parseData:(id)data
{
    NSArray * arr = [data mj_arrayValue];
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic = arr[i];
        SZCategoryModel  * model = [SZCategoryModel model];
        [model yy_modelSetWithDictionary:dic];
        [self.dataArr addObject:model];
    }
}

@end
