//
//  HttpManager.h
//  MJLife
//
//  Created by mgfjx on 2018/9/3.
//  Copyright © 2018年 Joseph_Xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessCallback)(id resultDict);
typedef void(^FailCallback)(NSError *error);

@interface HttpManager : NSObject

+ (instancetype)manager ;

- (void)startGetUrl:(NSString *)url param:(NSDictionary *)param success:(SuccessCallback)success_block failure:(FailCallback)failure_block ;

@end
