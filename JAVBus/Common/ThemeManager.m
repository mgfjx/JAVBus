//
//  ThemeManager.m
//  JAVBus
//
//  Created by mgfjx on 2021/7/19.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

static id singleton = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [super allocWithZone:zone];
        });
    }
    return singleton;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super init];
    });
    return singleton;
}

- (id)copyWithZone:(NSZone *)zone{
    return singleton;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return singleton;
}

+ (instancetype)manager {
    return [[self alloc] init];
}

- (UIColor *)pageBgColor {
    return [UIColor dynamicProviderWithDarkStr:@"#151515" lightStr:@"#ffffff"];
}

- (UIColor *)navColor {
    return [UIColor dynamicProviderWithDarkStr:@"#151515" lightStr:@"#ffffff"];
}

- (UIColor *)tabBarBgColor {
    return [UIColor dynamicProviderWithDarkStr:@"#151515" lightStr:@"#ffffff"];
}

- (UIColor *)cellBgColor {
    return [UIColor dynamicProviderWithDarkStr:@"#222222" lightStr:@"#606060"];
}

- (UIColor *)cellImageBgColor {
    return [UIColor dynamicProviderWithDarkStr:@"#151515" lightStr:@"#ffffff"];
}

- (UIColor *)cellBorderColor {
    return [UIColor dynamicProviderWithDarkStr:@"#333333" lightStr:@"#eeeeee"];
}

@end
