//
//  GoogleDriveManager.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/10.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleAPIClientForREST/GTLRDrive.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleDriveManager : NSObject

SingletonDeclare(Manager);


/// 上傳文件
- (void)uploadFile:(NSData *)fileData ;


/// 獲取所有文件夾及文件
- (void)getAllFileList:(void (^)(NSArray<GTLRDrive_File *> *fileList))callback ;

- (void)test ;

@end

NS_ASSUME_NONNULL_END
