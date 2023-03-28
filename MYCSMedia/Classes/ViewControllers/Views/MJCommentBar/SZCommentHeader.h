//
//  SZCommentHeader.h
//  MYCSMedia
//
//  Created by 马佳 on 2022/1/4.
//

#import <UIKit/UIKit.h>
#import "SZCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZCommentHeader : UICollectionReusableView

-(void)setCellData:(SZCommentModel*)data;
-(CGSize)getHeaderSize;

@end

NS_ASSUME_NONNULL_END
