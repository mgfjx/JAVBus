//
//  ZHChineseConvert.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/2.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "ZHChineseConvert.h"

@interface ZHChineseConvert ()

@property(nonatomic, strong) NSString *simplifiedCode;  //!< 简体中文码表.
@property(nonatomic, strong) NSString *traditionalCode; //!< 繁体中文码表.

@end

@implementation ZHChineseConvert

/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertSimplifiedToTraditional:(NSString *)simpString
{
    return [[ZHChineseConvert getInstance] convertSimplifiedToTraditional:simpString];
}


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString*)convertTraditionalToSimplified:(NSString*)tradString
{
    return [[ZHChineseConvert getInstance] convertTraditionalToSimplified:tradString];
}


// 获取单例对象
+ (instancetype)getInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 加载简体中文和繁体中文码表
        NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
        self.simplifiedCode = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"SimplifiedCode.txt"] encoding:NSUTF8StringEncoding error:nil];
        self.traditionalCode = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"TraditionalCode.txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}


/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
- (NSString *)convertSimplifiedToTraditional:(NSString *)simpString
{
    // 空值判断
    if (simpString.length == 0) {
        return nil;
    }
    
    // 存储转换结果
    NSMutableString *resultString = [NSMutableString string];
    
    // 遍历字符串中的字符
    NSInteger length = [simpString length];
    for (NSInteger i = 0; i < length; i++)
    {
        // 在简体中文中查找字符位置，如果存在则取出对应的繁体中文
        NSString *simCharString = [simpString substringWithRange:NSMakeRange(i, 1)];
        NSRange charRange = [self.simplifiedCode rangeOfString:simCharString];
        if(charRange.location != NSNotFound) {
            NSString *tradCharString = [self.traditionalCode substringWithRange:charRange];
            [resultString appendString:tradCharString];
        }else{
            [resultString appendString:simCharString];
        }
    }
    return resultString;
}


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
- (NSString *)convertTraditionalToSimplified:(NSString *)tradString
{
    // 空值判断
    if (tradString.length == 0) {
        return nil;
    }
    
    // 存储转换结果
    NSMutableString *resultString = [NSMutableString string];
    
    // 遍历字符串中的字符
    NSInteger length = [tradString length];
    for (NSInteger i = 0; i < length; i++)
    {
        // 在繁体中文中查找字符位置，如果存在则取出对应的简体中文
        NSString *tradCharString = [tradString substringWithRange:NSMakeRange(i, 1)];
        NSRange charRange = [self.traditionalCode rangeOfString:tradCharString];
        if(charRange.location != NSNotFound) {
            NSString *simCharString = [self.simplifiedCode substringWithRange:charRange];
            [resultString appendString:simCharString];
        }else{
            [resultString appendString:tradCharString];
        }
    }
    return resultString;
}

@end

