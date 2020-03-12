//
//  GoogleSDKManager.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/10.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GIDGoogleUser.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleSignInManager : NSObject

SingletonDeclare(Manager);

@property (nonatomic, strong) GIDGoogleUser *user ;

- (void)signIn ;

- (void)configration ;

@end

NS_ASSUME_NONNULL_END
