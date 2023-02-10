//
//  SZReplyListModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2022/1/5.
//

#import "SZReplyListModel.h"
#import "SZReplyModel.h"
#import "NSObject+MJCategory.h"
#import "YYModel.h"

@implementation SZReplyListModel

-(void)parseData:(id)data
{
    [self yy_modelSetWithDictionary:data];
    
    NSArray * comments = [data mj_valueForKey:@"records"];
    for (int i = 0; i<comments.count; i++)
    {
        NSDictionary * dic = comments[i];
        SZReplyModel * model = [SZReplyModel model];
        [model parseData:dic];
        [self.dataArr addObject:model];
    }
    
}

@end
