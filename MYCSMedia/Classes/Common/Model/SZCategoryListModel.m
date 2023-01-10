//
//  SZCategoryListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/1/12.
//

#import "SZCategoryListModel.h"
#import "SZCategoryModel.h"
#import "NSObject+MJCategory.h"


@implementation SZCategoryListModel

-(void)parseData:(id)data
{
    NSArray * arr = [data mj_arrayValue];
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic = arr[i];
        SZCategoryModel  * model = [SZCategoryModel model];
        [model modelSetWithDictionary:dic];
        [self.dataArr addObject:model];
    }
}

@end
