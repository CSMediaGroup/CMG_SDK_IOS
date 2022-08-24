//
//  CategoryListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/1/12.
//

#import "CategoryListModel.h"
#import "CategoryModel.h"
#import "NSObject+MJCategory.h"


@implementation CategoryListModel

-(void)parseData:(id)data
{
    NSArray * arr = [data mj_arrayValue];
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic = arr[i];
        CategoryModel  * model = [CategoryModel model];
        [model modelSetWithDictionary:dic];
        [self.dataArr addObject:model];
    }
}

@end
