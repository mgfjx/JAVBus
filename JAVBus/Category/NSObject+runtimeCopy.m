//
//  NSObject+runtimeCopy.m
//  Unity
//
//  Created by mgfjx on 2018/6/7.
//  Copyright © 2018年 XXL. All rights reserved.
//

#import "NSObject+runtimeCopy.h"
#import <objc/runtime.h>

@implementation NSObject (runtimeCopy)

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone: zone] init];
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar var = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:key];
        [copy setValue:value forKey:key];
    }
    free(ivars);
    return copy;
}

@end
