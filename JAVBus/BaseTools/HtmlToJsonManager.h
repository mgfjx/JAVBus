//
//  HtmlToJsonManager.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDetailModel.h"
#import "ActressModel.h"

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
- (void)parseActressDetailUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array, ActressModel *model))callback ;

/**
 获取欧美影片
 */
- (void)parseXvdieoListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 请求有码类别
 */
- (void)parseCensoredCategoryListCallback:(void (^)(NSArray *array))callback ;
/**
 请求无码类别
 */
- (void)parseUnCensoredCategoryListCallback:(void (^)(NSArray *array))callback ;

/**
 类别详情
 */
- (void)parseCategoryListUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 获取movie详情
 */
- (void)parseMovieDetailByUrl:(NSString *)url
               detailCallback:(void (^)(MovieDetailModel *model))detailCallback
             magneticCallback:(void (^)(NSArray *magneticList))magneticCallback ;

/**
 搜索影片
 */
- (void)parseSearchListByUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 搜索演员
 */
- (void)parseSearchActorListByUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback ;

/**
 解析论坛首页数据
 */
- (void)parseForumHomeDataCallback:(void (^)(NSArray *array))callback ;

@end
