//
//  SZTopicListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/27.
//

#import "SZTopicListModel.h"
#import "NSObject+MJCategory.h"
#import "SZContentModel.h"

@implementation SZTopicListModel

-(void)parseData:(id)data
{
    NSArray * arr = [data mj_valueForKey:@"records"];
    
    for (int i = 0; i<arr.count; i++)
    {
        NSDictionary * dic = arr[i];
        SZContentModel * model = [SZContentModel model];
        [model parseData:dic];
        [self.dataArr addObject:model];
    }
}

@end
