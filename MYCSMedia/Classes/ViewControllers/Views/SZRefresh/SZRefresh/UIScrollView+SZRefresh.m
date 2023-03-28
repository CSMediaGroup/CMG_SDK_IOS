//  代码地址: https://github.com/CoderMJLee/SZRefresh
//  UIScrollView+SZRefresh.m
//  SZRefresh
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+SZRefresh.h"
#import "SZRefreshHeader.h"
#import "SZRefreshFooter.h"
#import "SZRefreshTrailer.h"
#import <objc/runtime.h>

@implementation UIScrollView (SZRefresh)

#pragma mark - header
static const char SZRefreshHeaderKey = '\0';
- (void)setSz_header:(SZRefreshHeader *)sz_header
{
    if (sz_header != self.sz_header) {
        // 删除旧的，添加新的
        [self.sz_header removeFromSuperview];
        
        if (sz_header) {
            [self insertSubview:sz_header atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &SZRefreshHeaderKey,
                                 sz_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SZRefreshHeader *)sz_header
{
    return objc_getAssociatedObject(self, &SZRefreshHeaderKey);
}

#pragma mark - footer
static const char SZRefreshFooterKey = '\0';
- (void)setSz_footer:(SZRefreshFooter *)sz_footer
{
    if (sz_footer != self.sz_footer) {
        // 删除旧的，添加新的
        [self.sz_footer removeFromSuperview];
        if (sz_footer) {
            [self insertSubview:sz_footer atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &SZRefreshFooterKey,
                                 sz_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SZRefreshFooter *)sz_footer
{
    return objc_getAssociatedObject(self, &SZRefreshFooterKey);
}

#pragma mark - footer
static const char SZRefreshTrailerKey = '\0';
- (void)setSz_trailer:(SZRefreshTrailer *)sz_trailer {
    if (sz_trailer != self.sz_trailer) {
        // 删除旧的，添加新的
        [self.sz_trailer removeFromSuperview];
        if (sz_trailer) {
            [self insertSubview:sz_trailer atIndex:0];
        }
        // 存储新的
        objc_setAssociatedObject(self, &SZRefreshTrailerKey,
                                 sz_trailer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SZRefreshTrailer *)sz_trailer {
    return objc_getAssociatedObject(self, &SZRefreshTrailerKey);
}

#pragma mark - 过期
- (void)setFooter:(SZRefreshFooter *)footer
{
    self.sz_footer = footer;
}

- (SZRefreshFooter *)footer
{
    return self.sz_footer;
}

- (void)setHeader:(SZRefreshHeader *)header
{
    self.sz_header = header;
}

- (SZRefreshHeader *)header
{
    return self.sz_header;
}

#pragma mark - other
- (NSInteger)sz_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;

        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;

        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end
