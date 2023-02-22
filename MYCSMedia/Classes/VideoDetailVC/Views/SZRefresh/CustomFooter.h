//
//  CustomFooter.h
//  智慧长沙
//
//  Created by 马佳 on 2019/12/31.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//

#import "SZRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomFooter : SZRefreshAutoFooter

@property(strong,nonatomic)NSString * customNoMoreDataStr;
@property(strong,nonatomic)UILabel * MJStateLabel;
@property(assign,nonatomic)CGRect customFrame;
@end

NS_ASSUME_NONNULL_END
