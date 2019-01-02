//
//  PublicDialogManager.h
//  ThirdLibPackage
//
//  Created by mgfjx on 2017/11/11.
//  Copyright © 2017年 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicDialogManager : NSObject

+ (void)showText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration ;
+ (void)showText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration offset:(CGFloat)offset ;

+ (void)showWaittingInView:(UIView *)view hideDelay:(NSTimeInterval)duration ;
+ (void)showWaittingInView:(UIView *)view ;
+ (void)hideWaittingInView:(UIView *)view ;

@end
