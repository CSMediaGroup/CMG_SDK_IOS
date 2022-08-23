//
//  SZDataReport.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDataReport : NSObject

+ (void)report:(NSString *)action param:(NSDictionary *)param;

@end
