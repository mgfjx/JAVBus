//
//  UIScrollView+Refresh.h
//  ThirdLibPackage
//
//  Created by mgfjx on 2017/11/4.
//  Copyright © 2017年 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshingBlock)(UIScrollView *rfScrollView);

@interface UIScrollView (Refresh)

@property (nonatomic, assign) BOOL canPullDown ;
@property (nonatomic, assign) BOOL canPullUp ;
@property (nonatomic, copy) RefreshingBlock headerRefreshBlock ;
@property (nonatomic, copy) RefreshingBlock footerRefreshBlock ;

- (void)startHeaderRefreshing ;
- (void)startFooterRefreshing ;
- (void)stopHeaderRefreshing ;
- (void)stopFooterRefreshing ;

@end
