//
//  SZVideoDetailVC.h
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/27.
//

#import <UIKit/UIKit.h>


@interface SZVideoDetailVC : UIViewController




@property(assign,nonatomic)NSInteger detailType;            //0单条视频 1视频集合

@property(strong,nonatomic)NSString * albumId;               //合辑ID
@property(strong,nonatomic)NSString * albumName;            //合辑名
@property(strong,nonatomic)NSString * contentId;
@property(strong,nonatomic)NSString * category_name;            //火山的

@property(assign,nonatomic)BOOL isPreview;              //是否预览模式，预览模式是简化版的UI


@end
