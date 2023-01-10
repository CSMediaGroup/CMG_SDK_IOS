//
//  SZCommentDataModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/7.
//

#import "SZCommentDataModel.h"
#import "NSObject+MJCategory.h"
#import "SZCommentModel.h"
#import "NSObject+YYModel.h"
#import "YYKit.h"

@implementation SZCommentDataModel

-(void)parseData:(id)data
{
    [self modelSetWithDictionary:data];
    
    NSArray * comments = [data mj_valueForKey:@"records"];
    for (int i = 0; i<comments.count; i++)
    {
        NSDictionary * dic = comments[i];
        SZCommentModel * model = [SZCommentModel model];
        [model parseData:dic];
        [self.dataArr addObject:model];
    }
    
}

@end
