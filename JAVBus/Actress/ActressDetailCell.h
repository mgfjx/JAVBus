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

@end
