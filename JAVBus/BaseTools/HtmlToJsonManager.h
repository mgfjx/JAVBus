//
//  HtmlToJsonManager.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HtmlToJsonManager : NSObject

+ (instancetype)manager ;

- (void)testIp:(NSString *)ip callback:(void (^)(NSArray *array))callback ;

/**
 获取有码影片
 */
- (void)parseCensoredListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 获取无码影片
 */
- (void)parseUncensoredListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 有码女优列表

 @param page 分页
 */
- (void)parseActressDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 无码女优列表
 
 @param page 分页
 */
- (void)parseActressUncensoredListByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 女优详情列表页
 
 @param page 分页
 */
- (void)parseActressDetailUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 获取欧美影片
 */
- (void)parseXvdieoListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

@end
