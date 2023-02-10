//
//  SZVideoRelateModel.m
//  MYCSMedia
//
//  Created by 马佳 on 2021/8/5.
//

#import "SZVideoRelateModel.h"
#import "YYModel.h"

 

@implementation SZVideoRelateModel

-(void)parseData:(id)data
{
    NSDictionary * dic = data;
    NSArray * arr = [dic valueForKey:@"records"];
    
    for(int i = 0;i<arr.count;i++)
    {
        SZVideoRelateModel * model = [SZVideoRelateModel model];
        NSDictionary * dic = arr[i];
        [model yy_modelSetWithDictionary:dic];
        [self.dataArr addObject:model];
    }
}

@end
