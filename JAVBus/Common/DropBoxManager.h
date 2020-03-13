//
//  DropBoxManager.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

NS_ASSUME_NONNULL_BEGIN

@interface DropBoxManager : NSObject

@property (nonatomic, assign, readonly) BOOL isSignIn ;

SingletonDeclare(Manager);

- (void)configration ;

- (void)signIn ;
- (BOOL)handleUrl:(NSURL *)url ;

- (void)getAllFiles:(NSString *)searchPath callback:(void(^)(NSArray<DBFILESMetadata *> *fileList))completeCallback ;

//同步数据库
- (void)syncDBFiles:(void (^)(CGFloat progress))progressCallback completeCallback:(void (^)(BOOL completed))completeCallback ;

//恢复数据库
- (void)recoverDBFile:(DBFILESFileMetadata *)file
     progressCallback:(void (^)(CGFloat progress))progressCallback
     completeCallback:(void (^)(BOOL completed))completeCallback ;

@end

NS_ASSUME_NONNULL_END
