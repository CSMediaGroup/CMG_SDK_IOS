//
//  SZPanelListModel.m
//  CMG_SDK
//
//  Created by 马佳 on 2023/1/6.
//

#import "SZPanelListModel.h"
#import "SZPanelModel.h"

@implementation SZPanelListModel
-(void)parseData:(id)data
{
    NSArray * pannelArr = data;
    
    for (int i=0; i<pannelArr.count; i++)
    {
        NSDictionary * pannelDic = pannelArr[i];
        SZPanelModel * pannelModel = [SZPanelModel model];
        [pannelModel parseData:pannelDic];
        [self.dataArr addObject:pannelModel];
    }
}
@end
