//
//  NSString+RegExp.m
//  Unity
//
//  Created by mgfjx on 2017/8/21.
//  Copyright © 2017年 XXL. All rights reserved.
//

#import "NSString+RegExp.h"

@implementation NSString (RegExp)

- (BOOL)matchRegex:(NSString *)regex {
    if (!regex) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)matchPhoneNumber {
    return [self matchRegex:@"^1[34578]\\d{9}$"];
}

- (BOOL)matchEmail {
    return [self matchRegex:@"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+"];
}

- (NSArray *)matchGroupRegex:(NSString *)regex {
    if (!regex) {
        return @[];
    }
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    return results;
}

- (void)matchRegex:(NSString *)regex progress:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL *stop))block {
    
    if (!regex) {
        return;
    }
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    [regular enumerateMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) usingBlock:block];
    
}


@end
