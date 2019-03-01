//
//  Encrypt.h
//  Unity
//
//  Created by mgfjx on 16/7/25.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encrypt : NSObject

+ (NSString *)md5Encrypt32:(NSString *)str;
+ (NSString *)md5Encrypt16:(NSString *)str;

+ (NSString *)encodeBase64:(NSString *)str;
+ (NSString *)decodeBase64:(NSString *)str;

+ (NSString *)encodeDes:(NSString *)str key:(NSString *)key vi:(NSString *)vi;
+ (NSString *)decodeDes:(NSString *)str key:(NSString *)key vi:(NSString *)vi;

+ (NSString *)encodeAES:(NSString *)str key:(NSString *)key vi:(NSString *)vi;
+ (NSString *)decodeAES:(NSString *)str key:(NSString *)key vi:(NSString *)vi;

@end
