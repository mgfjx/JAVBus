//
//  NSString+XLHelper.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/14.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "NSString+XLHelper.h"

@implementation NSString (XLHelper)

- (NSString *)clearSpecialCharacter {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return temp;
}

//base64编码
- (NSString *)base64Encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64Str;
}

//base64解码
- (NSString *)base64Decode {
    NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64EncodingEndLineWithLineFeed];

    NSString *base64Decoded = [[NSString alloc]initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];

    return base64Decoded;
}

@end
