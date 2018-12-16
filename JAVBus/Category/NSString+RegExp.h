//
//  NSString+RegExp.h
//  Unity
//
//  Created by mgfjx on 2017/8/21.
//  Copyright © 2017年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegExp)

- (BOOL)matchRegex:(NSString *_Nullable)regex;
- (BOOL)matchPhoneNumber ;
- (BOOL)matchEmail ;

- (NSArray *_Nonnull)matchGroupRegex:(NSString *_Nullable)regex ;

- (void)matchRegex:(NSString *_Nullable)regex progress:(void (^_Nullable)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nullable stop))block ;

@end
