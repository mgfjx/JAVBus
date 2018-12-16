//
//  UIColor+Hex.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/6.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 hex string value e.g:0xFFFFFF
 */
@property (nonatomic, readonly) NSString *stringColor;

/**
 @param hexString   NSString e.g:@"0xFC5B13"
 @param alpha		alhpa
 */
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)colorWithHexString:(NSString *)hexString;

/**
 @param hexNumber   uint e.g:0xFC5B13
 @param alpha        alhpa
 */
+ (instancetype)colorWithHex:(uint)hexNumber alpha:(CGFloat)alpha ;
+ (instancetype)colorWithHex:(uint)hexNumber ;

/**
 randomColor
 */
+ (instancetype)randomColorWithAlpha:(CGFloat)alpha;
+ (instancetype)randomColor;
@end
