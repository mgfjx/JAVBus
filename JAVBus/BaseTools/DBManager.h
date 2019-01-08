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

@interface DBManager : NSObject

+ (instancetype)manager ;


/**
 插入女优数据
 */
- (BOOL)insertActress:(ActressModel *)model ;

/**
 查询收藏女优
 */
- (NSArray *)queryActressList ;

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
- (NSArray *)queryMovieList ;

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
- (NSArray *)queryMovieCacheList ;

/**
 判断是否已缓存该电影
 */
- (BOOL)isMovieCacheExsit:(MovieListModel *)model ;

@end
