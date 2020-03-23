//
//  UIColor+Hex.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/6.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

#pragma mark - hex color
+ (instancetype)colorWithHex:(uint)hexNumber alpha:(CGFloat)alpha {
    
    if (hexNumber > 0xFFFFFF) return nil;
    
    CGFloat red   = ((hexNumber >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexNumber >> 8) & 0xFF) / 255.0;
    CGFloat blue  = (hexNumber & 0xFF) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
    
}

+ (instancetype)colorWithHex:(uint)hexNumber {
    return [UIColor colorWithHex:hexNumber alpha:1.0];
}

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexString.length < 6) return defaultColor;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    if (hexString.length != 6) return defaultColor;
    
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[^A-F|^0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *result = [regular matchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];
    if (result.count > 0) return defaultColor;
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    //method2
    const char *char_str = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    int hexNum;
    sscanf(char_str, "%x", &hexNum);
    
    return [UIColor colorWithHex:hexNumber alpha:alpha];
}

+ (instancetype)colorWithHexString:(NSString *)hexString{
    return [UIColor colorWithHexString:hexString alpha:1.0f];
}

#pragma mark - random color
+ (instancetype)randomColor{
    return [UIColor randomColorWithAlpha:1.0];
}

+ (instancetype)randomColorWithAlpha:(CGFloat)alpha{
    
    CGFloat r = arc4random()%255/255.0;
    CGFloat g = arc4random()%255/255.0;
    CGFloat b = arc4random()%255/255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (NSString *)stringColor{
    
    CGColorRef cgColor = self.CGColor;
    
    int red = 0, green = 0, blue = 0;
    
    int size = (int)CGColorGetNumberOfComponents(cgColor);
    if (size == 4) {
        const CGFloat *components = CGColorGetComponents(cgColor);
        red = floor(components[0] * 255);
        green = floor(components[1] * 255);
        blue = floor(components[2] * 255);
    }
    
    if(size == 2){
        const CGFloat *components = CGColorGetComponents(cgColor);
        red = floor(components[0] * 255);
        green = red;
        blue = red;
    }
    
    int hexNumber = (red << 16) | (green << 8) | blue;
    
    char ch[7];
    sprintf(ch, "%06X", hexNumber);
    
    NSString *colorString = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    
    return colorString;
}

@end
