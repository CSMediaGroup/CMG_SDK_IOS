//
//  SZCommentDataModel.h
//  MYCSMedia
//
//  Created by 马佳 on 2021/6/7.
//

#import "SZBaseModel.h"
#import "SZCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SZCommentDataModel : SZBaseModel


@property (nonatomic , assign) NSInteger              pageIndex;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              total;

@end

NS_ASSUME_NONNULL_END
