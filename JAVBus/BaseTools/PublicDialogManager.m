//
//  PublicDialogManager.m
//  ThirdLibPackage
//
//  Created by mgfjx on 2017/11/11.
//  Copyright © 2017年 mgfjx. All rights reserved.
//

#import "PublicDialogManager.h"
#import "MBProgressHUD.h"

#define ContentColor [UIColor whiteColor]
#define BackgroundColor [UIColor blackColor]
#define BezelViewMargin 8.0f

MBProgressHUD *hudInstance ;

@implementation PublicDialogManager

+ (void)showText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration {
    [self showText:text inView:view duration:duration offset:0.0];
}

+ (void)showText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration offset:(CGFloat)offset {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = ContentColor;
    hud.margin = BezelViewMargin;
    hud.offset = CGPointMake(hud.offset.x, offset);
    hud.bezelView.backgroundColor = BackgroundColor;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:duration];
}

+ (void)showWaittingInView:(UIView *)view {
    [self showWaittingInView:view hideDelay:CGFLOAT_MAX];
}

+ (void)hideWaittingInView:(UIView *)view {
    [hudInstance hideAnimated:YES];
}

+ (void)showWaittingInView:(UIView *)view hideDelay:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = BackgroundColor;
    hud.contentColor = ContentColor;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:duration];
    hudInstance = hud;
}

@end
