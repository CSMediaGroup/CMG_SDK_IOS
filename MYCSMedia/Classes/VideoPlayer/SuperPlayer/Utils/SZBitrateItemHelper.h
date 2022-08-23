//
//  SZBitrateItemHelper.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "SZSuperPlayerModel.h"
#import "SZSuperPlayer.h"

@interface SZBitrateItemHelper : NSObject
@property NSInteger bitrate;
@property NSString *title;
@property int index;

+ (NSArray<SZSuperPlayerUrl *> *)sortWithBitrate:(NSArray<TXBitrateItem *> *)bitrates;


@end
