//
//  UIAlertView+ActionBlock.m
//  MigcAlertView
//
//  Created by 谢小龙 on 16/4/18.
//  Copyright © 2016年 xintong. All rights reserved.
//

#import "UIAlertView+ActionBlock.h"
#import <objc/runtime.h>
@implementation UIAlertView (ActionBlock)

- (void)setCallBack:(AlertCallBack)callBack{
    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
}

- (AlertCallBack)callBack{
    return objc_getAssociatedObject(self, @selector(callBack));
}

#pragma mark - action method 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.callBack) {
        self.callBack(alertView, buttonIndex);
    }
}

- (void)dealloc{
    NSLog(@"%@ dead", NSStringFromClass([self class]));
}
@end
