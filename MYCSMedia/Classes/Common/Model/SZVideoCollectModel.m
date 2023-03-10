//
//  SZVideoCollectModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/5.
//

#import "SZVideoCollectModel.h"
#import "NSObject+MJCategory.h"
#import "NSObject+YYModel.h"
#import "YYModel.h"

@implementation SZVideoCollectModel
-(void)parseData:(id)data
{
    [self yy_modelSetWithDictionary:data];

    NSArray * arr = [data mj_valueForKey:@"children"];
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic = arr[i];
        SZContentModel * model = [SZContentModel  model];
        [model yy_modelSetWithDictionary:dic];
        [self.dataArr addObject:model];
    }
}

@end
