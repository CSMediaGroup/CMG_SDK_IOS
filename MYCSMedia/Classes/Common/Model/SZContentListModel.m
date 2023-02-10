//
//  SZContentListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/3.
//

#import "SZContentListModel.h"
#import "NSObject+MJCategory.h"
#import "SZContentModel.h"
#import "YYModel.h"


@implementation SZContentListModel
-(void)parseData:(id)data
{
    NSArray * arr = [data mj_arrayValue];
    for (int i = 0; i<arr.count; i++)
    {
        SZContentModel * model = [SZContentModel model];
        NSDictionary * dic = data[i];
        
        [model yy_modelSetWithDictionary:dic];

        [self.dataArr addObject:model];
    }
}

@end
