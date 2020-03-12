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

SingletonDeclare(Manager);

- (void)configration ;

- (void)signIn ;
- (BOOL)handleUrl:(NSURL *)url ;

- (void)getAllFiles:(void(^)(NSArray<DBFILESMetadata *> *fileList))completeCallback ;

@end

NS_ASSUME_NONNULL_END
