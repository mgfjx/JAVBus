//
//  PublicDialogManager.m
//  ThirdLibPackage
//
//  Created by mgfjx on 2017/11/11.
//  Copyright © 2017年 mgfjx. All rights reserved.
//

#import "PublicDialogManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define ContentColor [UIColor whiteColor]
#define BackgroundColor [UIColor blackColor]
#define BezelViewMargin 8.0f

MBProgressHUD *hudInstance ;
static dispatch_source_t currentTimer;

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

+ (void)test:(UIView *)view callback:(CGFloat (^)(void))callback {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set some text to show the initial status.
//    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    currentTimer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        CGFloat progress = callback();
        if (progress >= 1.0) {
            [hud hideAnimated:YES];
        }else{
            hud.progress = progress;
        }
    });
    dispatch_resume(timer);
    
}

@end
