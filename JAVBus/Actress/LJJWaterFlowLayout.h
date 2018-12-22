//
//  LJJWaterFlowLayout.h
//  WaterFlowDemo
//
//  Created by 俊杰  廖 on 2018/10/15.
//  Copyright © 2018年 俊杰  廖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJWaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak,nullable) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic,strong) NSMutableDictionary *attributes;//存放item的位置信息
@property (nonatomic,strong) NSMutableArray *cloArray;//存放每一个列的高度的数组
@end

NS_ASSUME_NONNULL_END
