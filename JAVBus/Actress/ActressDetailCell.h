//
//  ActressDetailCell.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/17.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieListModel.h"

@interface ActressDetailCell : UICollectionViewCell

@property (nonatomic, strong) MovieListModel *model ;
@property (nonatomic, strong) UIFont *titleFont ;

@property (nonatomic, assign) CGFloat itemHeight ;

/**
 显示操作控件
 */
@property (nonatomic, assign) BOOL showOperation ;
@property (nonatomic, copy) void (^actionCallback) (MovieListModel *model) ;

@end
