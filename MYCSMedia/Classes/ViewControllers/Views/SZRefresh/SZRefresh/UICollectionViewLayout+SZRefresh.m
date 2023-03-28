//
//  UICollectionViewLayout+SZRefresh.m
//
//  该类是用来解决 Footer 在底端加载完成后, 仍停留在原处的 bug.
//  此问题出现在 iOS 14 及以下系统上.
//  Reference: https://github.com/CoderMJLee/SZRefresh/issues/1552
//
//  Created by jiasong on 2021/11/15.
//  Copyright © 2021 小码哥. All rights reserved.
//

#import "UICollectionViewLayout+SZRefresh.h"
#import "SZRefreshConst.h"
#import "SZRefreshFooter.h"
#import "UIScrollView+SZRefresh.h"

@implementation UICollectionViewLayout (SZRefresh)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SZRefreshExchangeImplementations(self.class, @selector(finalizeCollectionViewUpdates),
                                         self.class, @selector(sz_finalizeCollectionViewUpdates));
    });
}

- (void)sz_finalizeCollectionViewUpdates {
    [self sz_finalizeCollectionViewUpdates];
    
    __kindof SZRefreshFooter *footer = self.collectionView.sz_footer;
    CGSize newSize = self.collectionViewContentSize;
    CGSize oldSize = self.collectionView.contentSize;
    if (footer != nil && !CGSizeEqualToSize(newSize, oldSize)) {
        NSDictionary *changed = @{
            NSKeyValueChangeNewKey: [NSValue valueWithCGSize:newSize],
            NSKeyValueChangeOldKey: [NSValue valueWithCGSize:oldSize],
        };
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [footer scrollViewContentSizeDidChange:changed];
        [CATransaction commit];
    }
}

@end
