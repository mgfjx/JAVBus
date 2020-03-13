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
            NSString *title = @"";
            NSString *message = @"";
            if (routeError) {
                // Route-specific request error
                title = @"Route-specific error";
                if ([routeError isPath]) {
                    message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
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
    }];
    
}

@end
