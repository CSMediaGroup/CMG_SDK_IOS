//
//  CustomAnimatedHeader.h
//  智慧长沙
//
//  Created by 马佳 on 2019/12/17.
//  Copyright © 2019 ChangShaBroadcastGroup. All rights reserved.
//


#import "SZRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomAnimatedHeader : SZRefreshStateHeader
@property(strong,nonatomic)UIImageView * loadingImage;
@property(strong,nonatomic)UILabel * loadingLabel;
@end

NS_ASSUME_NONNULL_END
