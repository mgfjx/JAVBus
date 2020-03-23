//
//  GoogleSignInManager.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/10.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GoogleSignInManager.h"
#import <GoogleSignIn/GIDSignIn.h>
#import <GoogleSignIn/GIDSignInButton.h>
#import <GoogleSignIn/GIDProfileData.h>
#import <GoogleSignIn/GIDAuthentication.h>

#define kClientID @"693888897199-321kcv0332tb063q0ioiqpiu9857bqi5.apps.googleusercontent.com"

@interface GoogleSignInManager ()<GIDSignInDelegate>

@end

@implementation GoogleSignInManager

SingletonImplement(Manager);

- (void)configration {
    [GIDSignIn sharedInstance].clientID = kClientID;
    [GIDSignIn sharedInstance].scopes = @[
        @"https://www.googleapis.com/auth/drive.appdata",
        @"https://www.googleapis.com/auth/drive.file",
        @"https://www.googleapis.com/auth/drive.install"
    ];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [[GIDSignIn sharedInstance] restorePreviousSignIn];
    GIDGoogleUser *user = [GIDSignIn sharedInstance].currentUser;
    if (user) {
        self.user = user;
    }
}

- (void)signIn {
    [GIDSignIn sharedInstance].presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark - GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
            NSLog(@"The user has not signed in before or they have since signed out.");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        self.user = nil;
        return;
    }
    NSLog(@"Google SignIned: %@", user);
    self.user = user;
}

@end
