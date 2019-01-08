//
//  DBManager.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "DBManager.h"
#import <FMDB/FMDB.h>

static DBManager *singleton ;

@interface DBManager ()

@property (nonatomic, strong) FMDatabase *db ;

@end

@implementation DBManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[DBManager alloc] init];
        [singleton initDataBase];
    });
    return singleton ;
}

- (void)initDataBase {
    
    NSString *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    dbPath = [NSString stringWithFormat:@"%@/JavBus.db", dbPath];
    NSLog(@"dbPath: %@", dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    self.db = db;
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    
    {
        NSString *sql = @"create table if not exists ActressCollectionTable ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'link' TEXT NOT NULL,'avatarUrl' TTEXT NOT NULL)";
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
        }
    }
    
    {
        NSString *sql = @"create table if not exists MovieCollectionTable ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'title' TEXT, 'link' TEXT,'imgUrl' TEXT,'number' TEXT,'dateString' TEXT)";
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
        }
    }
    
    {
        NSString *sql = @"create table if not exists MovieCachedTable ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'title' TEXT, 'link' TEXT,'imgUrl' TEXT,'number' TEXT,'dateString' TEXT)";
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
        }
    }
    
    [db close];
    
}

- (BOOL)baseUpdateSql:(NSString *)sql {
    [self.db open];
    BOOL result = [self.db executeUpdate:sql];
    [self.db close];
    return result;
}

/**
 判断是否已收藏该女优
 */
- (BOOL)isActressExsit:(ActressModel *)model {
    NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from ActressCollectionTable where name='%@'", model.name];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    int count = 0;
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    [self.db close];
    return count > 0;
}

/**
 插入女优数据
 */
- (BOOL)insertActress:(ActressModel *)model {
    BOOL isExsit = [self isActressExsit:model];
    if (isExsit) {
        return YES;
    }
    NSString *sql = [NSString stringWithFormat:@"insert into 'ActressCollectionTable'(name,link,avatarUrl) values('%@','%@','%@')", model.name, model.link, model.avatarUrl];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除女优数据
 */
- (BOOL)deleteActress:(ActressModel *)model {
    NSString *sql = [NSString stringWithFormat:@"delete from ActressCollectionTable where name='%@'", model.name];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除所有女优数据
 */
- (BOOL)deleteAllActress {
    NSString *sql = @"delete from ActressCollectionTable";
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 查询收藏女优
 */
- (NSArray *)queryActressList {
    NSString *sql = [NSString stringWithFormat:@"select * from 'ActressCollectionTable'"];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        ActressModel *model = [ActressModel new];
        model.name = [result stringForColumn:@"name"];
        model.link = [result stringForColumn:@"link"];
        model.avatarUrl = [result stringForColumn:@"avatarUrl"];
        [arr addObject:model];
    }
    [self.db close];
    return [arr copy];
}

/**
 插入电影数据
 */
- (BOOL)insertMovie:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"insert into 'MovieCollectionTable'(title,link,imgUrl,number,dateString) values('%@','%@','%@','%@','%@')", model.title, model.link, model.imgUrl,model.number,model.dateString];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除电影数据
 */
- (BOOL)deleteMovie:(MovieListModel *)model {
    BOOL isExsit = [self isMovieExsit:model];
    if (isExsit) {
        return YES;
    }
    NSString *sql = [NSString stringWithFormat:@"delete from MovieCollectionTable where number='%@'", model.number];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除所有电影数据
 */
- (BOOL)deleteAllMovie {
    NSString *sql = @"delete from MovieCollectionTable";
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 查询收藏电影
 */
- (NSArray *)queryMovieList {
    NSString *sql = [NSString stringWithFormat:@"select * from 'MovieCollectionTable'"];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        MovieListModel *model = [MovieListModel new];
        model.title = [result stringForColumn:@"title"];
        model.link = [result stringForColumn:@"link"];
        model.imgUrl = [result stringForColumn:@"imgUrl"];
        model.number = [result stringForColumn:@"number"];
        model.dateString = [result stringForColumn:@"dateString"];
        [arr addObject:model];
    }
    [self.db close];
    return [arr copy];
}

/**
 判断是否已收藏该电影
 */
- (BOOL)isMovieExsit:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from MovieCollectionTable where number='%@'", model.number];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    int count = 0;
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    [self.db close];
    return count > 0;
}

/**
 插入电影缓存数据
 */
- (BOOL)insertMovieCache:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"insert into 'MovieCachedTable'(title,link,imgUrl,number,dateString) values('%@','%@','%@','%@','%@')", model.title, model.link, model.imgUrl,model.number,model.dateString];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除电影缓存数据
 */
- (BOOL)deleteMovieCache:(MovieListModel *)model {
    BOOL isExsit = [self isMovieCacheExsit:model];
    if (isExsit) {
        return YES;
    }
    NSString *sql = [NSString stringWithFormat:@"delete from MovieCachedTable where number='%@'", model.number];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除所有电影缓存数据
 */
- (BOOL)deleteAllMovieCache {
    NSString *sql = @"delete from MovieCachedTable";
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 查询缓存电影
 */
- (NSArray *)queryMovieCacheList {
    NSString *sql = [NSString stringWithFormat:@"select * from 'MovieCachedTable'"];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        MovieListModel *model = [MovieListModel new];
        model.title = [result stringForColumn:@"title"];
        model.link = [result stringForColumn:@"link"];
        model.imgUrl = [result stringForColumn:@"imgUrl"];
        model.number = [result stringForColumn:@"number"];
        model.dateString = [result stringForColumn:@"dateString"];
        [arr addObject:model];
    }
    [self.db close];
    return [arr copy];
}

/**
 判断是否已缓存该电影
 */
- (BOOL)isMovieCacheExsit:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from MovieCachedTable where number='%@'", model.number];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    int count = 0;
    while ([result next]) {
        count = [result intForColumnIndex:0];
    }
    [self.db close];
    return count > 0;
}

@end
