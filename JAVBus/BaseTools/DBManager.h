//
//  DBManager.h
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActressModel.h"
#import "MovieListModel.h"
#import "TitleLinkModel.h"
#import "ScreenShotModel.h"
#import "RecommendModel.h"
#import "MagneticModel.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *dbPath ;
+ (instancetype)manager ;


/**
 插入女优数据
 */
- (BOOL)insertActress:(ActressModel *)model ;

/**
 查询收藏女优
 */
- (NSArray *)queryActressList:(NSInteger)pageSize ;

/**
 判断是否已收藏该女优
 */
- (BOOL)isActressExsit:(ActressModel *)model ;

/**
 删除女优数据
 */
- (BOOL)deleteActress:(ActressModel *)model ;

/**
 删除所有女优数据
 */
- (BOOL)deleteAllActress ;

/**
 插入电影数据
 */
- (BOOL)insertMovie:(MovieListModel *)model ;

/**
 删除电影数据
 */
- (BOOL)deleteMovie:(MovieListModel *)model ;

/**
 删除所有电影数据
 */
- (BOOL)deleteAllMovie ;

/**
 查询收藏电影
 */
- (NSArray *)queryMovieList:(NSInteger)pageSize ;

/**
 判断是否已收藏该电影
 */
- (BOOL)isMovieExsit:(MovieListModel *)model ;

/**
 插入电影缓存数据
 */
- (BOOL)insertMovieCache:(MovieListModel *)model ;

/**
 删除电影缓存数据
 */
- (BOOL)deleteMovieCache:(MovieListModel *)model ;

/**
 删除所有电影缓存数据
 */
- (BOOL)deleteAllMovieCache ;

/**
 查询缓存电影
 */
- (NSArray *)queryMovieCacheList:(NSInteger)pageSize;

/**
 判断是否已缓存该电影
 */
- (BOOL)isMovieCacheExsit:(MovieListModel *)model ;

/**
 插入电影详情数据
 */
- (BOOL)insertMovieDetail:(MovieDetailModel *)model ;

/**
 更新电影详情数据
 */
- (BOOL)updateMovieDetail:(MovieDetailModel *)model ;

/**
 判断是否已存在电影详情
 */
- (BOOL)isMovieDetailExsit:(MovieListModel *)model ;

/**
 查询电影详情
 */
- (MovieDetailModel *)queryMovieDetail:(MovieListModel *)model ;

/**
 删除电影详情数据
 */
- (BOOL)deleteMovieDetail:(MovieDetailModel *)model ;

/**
 删除所有电影缓存数据
 */
- (BOOL)deleteAllCacheMovie ;

@end
