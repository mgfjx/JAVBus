//
//  UIAlertView+ActionBlock.h
//  MigcAlertView
//
//  Created by 谢小龙 on 16/4/18.
//  Copyright © 2016年 xintong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertCallBack)(UIAlertView *, NSUInteger);

@interface UIAlertView (ActionBlock)<UIAlertViewDelegate>

@property (nonatomic, copy) AlertCallBack callBack;

@end
