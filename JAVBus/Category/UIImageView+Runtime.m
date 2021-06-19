//
//  UIImageView+Runtime.m
//  JAVBus
//
//  Created by mgfjx on 2021/2/22.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "UIImageView+Runtime.h"
#import <objc/runtime.h>

#pragma mark - 方法交换

static inline void sq_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIImageView (Runtime)

+ (void)load {
    
    //方法交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        sq_swizzleSelector(class, @selector(setImage:), @selector(xl_setImage:));
    });
    
}

- (void)xl_setImage:(UIImage *)image {
    if (!kCloseImage) {
        [self xl_setImage:image];
    }
}

@end
