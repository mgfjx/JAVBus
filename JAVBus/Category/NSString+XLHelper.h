//
//  NSString+XLHelper.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/14.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XLHelper)

- (NSString *)clearSpecialCharacter ;

//base64编码
- (NSString *)base64Encode ;

//base64解码
- (NSString *)base64Decode ;

@end

NS_ASSUME_NONNULL_END
