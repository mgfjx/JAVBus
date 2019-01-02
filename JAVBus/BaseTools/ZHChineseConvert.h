//
//  ZHChineseConvert.h
//  JAVBus
//
//  Created by mgfjx on 2019/1/2.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHChineseConvert : NSObject

/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertSimplifiedToTraditional:(NSString *)simpString;


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString*)convertTraditionalToSimplified:(NSString*)tradString;

@end
