//  代码地址: https://github.com/CoderMJLee/SZRefresh

#import <Foundation/Foundation.h>

#if __has_include(<SZRefresh/SZRefresh.h>)
FOUNDATION_EXPORT double SZRefreshVersionNumber;
FOUNDATION_EXPORT const unsigned char SZRefreshVersionString[];

#import <SZRefresh/UIScrollView+SZRefresh.h>
#import <SZRefresh/UIScrollView+SZExtension.h>
#import <SZRefresh/UIView+SZExtension.h>

#import <SZRefresh/SZRefreshNormalHeader.h>
#import <SZRefresh/SZRefreshGifHeader.h>

#import <SZRefresh/SZRefreshBackNormalFooter.h>
#import <SZRefresh/SZRefreshBackGifFooter.h>
#import <SZRefresh/SZRefreshAutoNormalFooter.h>
#import <SZRefresh/SZRefreshAutoGifFooter.h>

#import <SZRefresh/SZRefreshNormalTrailer.h>
#import <SZRefresh/SZRefreshConfig.h>
#import <SZRefresh/NSBundle+SZRefresh.h>
#import <SZRefresh/SZRefreshConst.h>


#else
#import "UIScrollView+SZRefresh.h"
#import "UIScrollView+SZExtension.h"
#import "UIView+SZExtension.h"

#import "SZRefreshNormalHeader.h"
#import "SZRefreshGifHeader.h"

#import "SZRefreshBackNormalFooter.h"
#import "SZRefreshBackGifFooter.h"
#import "SZRefreshAutoNormalFooter.h"
#import "SZRefreshAutoGifFooter.h"

#import "SZRefreshNormalTrailer.h"
#import "SZRefreshConfig.h"
#import "NSBundle+SZRefresh.h"
#import "SZRefreshConst.h"
#endif
