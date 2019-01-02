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

/**
 根据番号从Avgle获取预览视频
 
 @param code 番号
 */
- (void)getVideoByCode:(NSString *)code SuccessCallback:(SuccessCallback)success FailCallback:(FailCallback)failed ;

@end
