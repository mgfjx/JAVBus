//
//  JXCategoryComponentCellModel.h
//  DQGuess
//
//  Created by jiaxin on 2018/7/25.
//  Copyright © 2018年 jingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryBaseCellModel.h"

@interface JXCategoryIndicatorCellModel : JXCategoryBaseCellModel

@property (nonatomic, assign) BOOL sepratorLineShowEnabled;

@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame;

@property (nonatomic, assign) BOOL cellBackgroundColorGradientEnabled;

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

@end
