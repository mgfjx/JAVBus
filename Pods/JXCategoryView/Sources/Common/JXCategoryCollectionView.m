//
//  JXCategoryCollectionView.m
//  UI系列测试
//
//  Created by jiaxin on 2018/3/21.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryCollectionView.h"

@implementation JXCategoryCollectionView

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (UIView<JXCategoryIndicatorProtocol> *view in self.indicators) {
        [self sendSubviewToBack:view];
    }
}

@end
