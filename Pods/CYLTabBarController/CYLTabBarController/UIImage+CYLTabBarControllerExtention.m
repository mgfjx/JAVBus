//
//  UIImage+CYLTabBarControllerExtention.m
//  CYLTabBarController
//
//  Created by chenyilong on 18/4/2019.
//  Copyright © 2019 微博@iOS程序犭袁. All rights reserved.
//

#import "UIImage+CYLTabBarControllerExtention.h"

@implementation UIImage (CYLTabBarControllerExtention)

+ (UIImage *)cyl_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)cyl_assetImageName:(NSString *)assetImageName
             userInterfaceStyle:(NSInteger)userInterfaceStyle  {
    UIImage *image = [UIImage imageNamed:@"image"];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
#if __has_include(<UIKit/UIScene.h>)
        UITraitCollection *trait;
//        UIUserInterfaceStyle currentUserInterfaceStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
//        if (currentUserInterfaceStyle == UIUserInterfaceStyleUnspecified) {
//            currentUserInterfaceStyle == userInterfaceStyle;
//        }
        trait = [UITraitCollection traitCollectionWithUserInterfaceStyle:userInterfaceStyle];
        image = [image.imageAsset imageWithTraitCollection:trait];
        //TODO:
        return image;
#else
#endif
    }
#endif
    return image;
}

+ (UIImage *)cyl_lightOrDarkModeImageWithLightImage:(UIImage *)lightImage
                                     darkImage:(UIImage *)darkImage  {
    return [self cyl_lightOrDarkModeImageWithOwner:nil lightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)cyl_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                 lightImageName:(NSString *)lightImageName
                  darkImageName:(NSString *)darkImageName {
    UIImage *lightImage = [UIImage imageNamed:lightImageName];
    UIImage *darkImage= [UIImage imageNamed:darkImageName];
    UIImage *lightOrDarkImage = [UIImage cyl_lightOrDarkModeImageWithOwner:owner lightImage:lightImage darkImage:darkImage];
    return lightOrDarkImage;
}

+ (UIImage *)cyl_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                                    lightImage:(UIImage *)lightImage
                                     darkImage:(UIImage *)darkImage {
    BOOL isDarkImage = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
#if __has_include(<UIKit/UIScene.h>)
        //TODO:
        UITraitCollection *traitCollection = owner.traitCollection ?: [UITraitCollection currentTraitCollection];
        UIUserInterfaceStyle userInterfaceStyle = traitCollection.userInterfaceStyle;
        isDarkImage = (userInterfaceStyle == UIUserInterfaceStyleDark);
#else
#endif
    }
#endif
    UIImage *image = (isDarkImage ? darkImage : lightImage);
    return image;
}

@end
