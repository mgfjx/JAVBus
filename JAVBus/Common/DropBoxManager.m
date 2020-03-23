//
//  DropBoxManager.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "DropBoxManager.h"

@implementation DropBoxManager

SingletonImplement(Manager);

- (void)configration {
    NSString *appKey = @"5h5tj0ko73y8qqa";
    NSString *registeredUrlToHandle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0];
    if (!appKey || [registeredUrlToHandle containsString:@"<"]) {
        NSString *message = @"You need to set `appKey` variable in `AppDelegate.m`, as well as add to `Info.plist`, before you can use DBRoulette.";
        NSLog(@"%@", message);
    }
    [DBClientsManager setupWithAppKey:appKey];
}

- (void)signIn {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController ;
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication] controller:rootVC openURL:^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
}

- (BOOL)isSignIn {
    return [DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient];
}

- (BOOL)handleUrl:(NSURL *)url {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
            return YES;
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
    return NO;
}

- (void)getAllFiles:(NSString *)searchPath callback:(void(^)(NSArray<DBFILESMetadata *> *fileList))completeCallback {
    
    if (!searchPath) {
        searchPath = @"";
    }
    
    if (!self.isSignIn) {
        if (completeCallback) {
            completeCallback(@[]);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self signIn];
        });
        return;
    }
    
    DBUserClient *client = [DBClientsManager authorizedClient];
    
    // list folder metadata contents (folder will be root "/" Dropbox folder if app has permission
    // "Full Dropbox" or "/Apps/<APP_NAME>/" if app has permission "App Folder").
    [[client.filesRoutes listFolder:searchPath]
     setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
            NSArray *fileList = result.entries;
            if (completeCallback) {
                completeCallback(fileList);
            }
        } else {
            if (completeCallback) {
                completeCallback(@[]);
            }
            
        }
    }];
    
}

//同步数据库
- (void)syncDBFiles:(void (^)(CGFloat progress))progressCallback completeCallback:(void (^)(BOOL completed))completeCallback {
    
    NSData *fileData = [NSData dataWithContentsOfFile:[DBManager manager].dbPath];
    
    if (!fileData) {
        NSLog(@"fileData 为空!");
        return;
    }
    
    // For overriding on upload
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
    
    DBUserClient *client = [DBClientsManager authorizedClient];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeDeterminate;
    [[[client.filesRoutes uploadData:@"/JAVBus/JavBus.db"
                                mode:mode
                          autorename:@(YES)
                      clientModified:nil
                                mute:@(NO)
                      propertyGroups:nil
                      strictConflict:nil
                           inputData:fileData]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
        if (result) {
            NSLog(@"%@\n", result);
            if (completeCallback) {
                completeCallback(YES);
            }
        } else {
            NSLog(@"%@\n%@\n", routeError, networkError);
            if (completeCallback) {
                completeCallback(NO);
            }
            [self dealWithRouteError:routeError requestError:networkError];
        }
    }] setProgressBlock:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
        NSLog(@"上传进度: %f", totalBytesUploaded*1.0/totalBytesExpectedToUploaded);
        CGFloat upload = totalBytesUploaded*1.0/totalBytesExpectedToUploaded;
        if (progressCallback) {
            progressCallback(upload);
        }
    }];
    
}

//恢复数据库
- (void)recoverDBFile:(DBFILESFileMetadata *)file
     progressCallback:(void (^)(CGFloat progress))progressCallback
     completeCallback:(void (^)(BOOL completed))completeCallback { 
    
    NSString *pathDisplay = file.pathDisplay;
    
    DBUserClient *client = [DBClientsManager authorizedClient];
    [[[client.filesRoutes downloadData:pathDisplay]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileData) {
        if (result) {
            NSString *filePath = [DBManager manager].dbPath;
            [fileData writeToFile:filePath atomically:YES];
            if (completeCallback) {
                completeCallback(YES);
            }
        } else {
            [self dealWithRouteError:routeError requestError:error];
            if (completeCallback) {
                completeCallback(NO);
            }
        }
    }] setProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"上传进度: %f", totalBytesWritten*1.0/totalBytesExpectedToWrite);
        CGFloat progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
        if (progressCallback) {
            progressCallback(progress);
        }
    }];
    
}


/// 处理错误
- (void)dealWithRouteError:(id)routeError requestError:(DBRequestError *)error {
    
    
    NSString *title = @"";
    NSString *message = @"";
    BOOL isPath = NO;
    id path = @"";
    
    if ([routeError isKindOfClass:[DBFILESDownloadError class]]) {
        DBFILESDownloadError *downloadError = (DBFILESDownloadError *)routeError;
        isPath = [downloadError isPath];
        path = downloadError.path;
    }
    
    if ([routeError isKindOfClass:[DBFILESUploadError class]]) {
        DBFILESUploadError *downloadError = (DBFILESUploadError *)routeError;
        isPath = [downloadError isPath];
        path = downloadError.path;
    }
    
    if (routeError) {
        // Route-specific request error
        title = @"Route-specific error";
        if (isPath) {
            message = [NSString stringWithFormat:@"Invalid path: %@", path];
        }
    } else {
        // Generic request error
        title = @"Generic request error";
        if ([error isInternalServerError]) {
            DBRequestInternalServerError *internalServerError = [error asInternalServerError];
            message = [NSString stringWithFormat:@"%@", internalServerError];
        } else if ([error isBadInputError]) {
            DBRequestBadInputError *badInputError = [error asBadInputError];
            message = [NSString stringWithFormat:@"%@", badInputError];
        } else if ([error isAuthError]) {
            DBRequestAuthError *authError = [error asAuthError];
            message = [NSString stringWithFormat:@"%@", authError];
        } else if ([error isRateLimitError]) {
            DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
            message = [NSString stringWithFormat:@"%@", rateLimitError];
        } else if ([error isHttpError]) {
            DBRequestHttpError *genericHttpError = [error asHttpError];
            message = [NSString stringWithFormat:@"%@", genericHttpError];
        } else if ([error isClientError]) {
            DBRequestClientError *genericLocalError = [error asClientError];
            message = [NSString stringWithFormat:@"%@", genericLocalError];
        }
    }
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                      handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
