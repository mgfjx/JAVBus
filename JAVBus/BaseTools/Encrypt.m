//
//  Encrypt.m
//  Unity
//
//  Created by mgfjx on 16/7/25.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation Encrypt

+ (NSString *)md5Encrypt32:(NSString *)str{
    
    CC_LONG length = CC_MD5_DIGEST_LENGTH;
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[length];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *reStr = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [reStr appendFormat:@"%02x", result[i]];
    }
    
    return [reStr copy];
}

+ (NSString *)md5Encrypt16:(NSString *)str{
    //取32md5加密中间16位
    NSString *result = [self md5Encrypt32:str];
    return [result substringWithRange:NSMakeRange(8, 16)];
}

+ (NSString *)encodeBase64:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
    NSString *base64Encode = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64Encode;
}

+ (NSString *)decodeBase64:(NSString *)str{
    
    NSData *dataBase64 = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *base64Decode = [[NSString alloc] initWithData:dataBase64 encoding:NSASCIIStringEncoding];
    return base64Decode;
}

#pragma mark - des
+ (NSString *)encodeDes:(NSString *)str key:(NSString *)key vi:(NSString *)iv{
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    size_t dataSize = [data length];
    const void *dataIn = [data bytes];
    
    const void *cKey = (void *)[key UTF8String];
    const void *cIv = (void *)[iv UTF8String];
    
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    CCCrypt(kCCEncrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            cKey,
            kCCKeySize3DES,
            cIv,
            dataIn,
            dataSize,
            (void *)dataOut,
            dataOutAvailable,
            &dataOutMoved);
    
    NSData *resultData = [[NSData alloc] initWithBytes:(const void *)dataOut length:(NSInteger)dataOutMoved];
    NSString *resultStr = [resultData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    free(dataOut);
    
    return resultStr;
}

+ (NSString *)decodeDes:(NSString *)str key:(NSString *)key vi:(NSString *)iv{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    size_t dataSize = [data length];
    const void *dataIn = [data bytes];
    
    const void *cKey = (void *)[key UTF8String];
    const void *cIv = (void *)[iv UTF8String];
    
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    CCCrypt(kCCDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            cKey,
            kCCKeySize3DES,
            cIv,
            dataIn,
            dataSize,
            (void *)dataOut,
            dataOutAvailable,
            &dataOutMoved);
    
    NSData *resultData = [[NSData alloc] initWithBytes:(const void *)dataOut length:(NSInteger)dataOutMoved];
    NSString *resultStr = [[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding];
    free(dataOut);
    
    return resultStr;
}

+ (NSString *)encodeAES:(NSString *)str key:(NSString *)key vi:(NSString *)iv {
    
    NSString *const kInitVector = iv;
    size_t const kKeySize = kCCKeySizeAES128;
    
    NSData *contentData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
    
}


+ (NSString *)decodeAES:(NSString *)str key:(NSString *)key vi:(NSString *)iv {
    NSString *const kInitVector = iv;
    size_t const kKeySize = kCCKeySizeAES128;
    
    // 把 base64 String 转换成 Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }
    free(decryptedBytes);
    return nil;
}

@end
