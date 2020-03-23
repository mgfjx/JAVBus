//
//  DBManager.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "DBManager.h"
#import <fmdb/FMDB.h>

static DBManager *singleton ;

#define LimitSize 50;

@interface DBManager ()

@property (nonatomic, strong) FMDatabase *db ;

@end

@implementation DBManager

#pragma mark 字典转化字符串
- (NSString *)objectToJson:(id)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *temp = [json stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *result = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

- (id)objectWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}

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
    self.dbPath = dbPath ;
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
    
    //影片详情页
    {
        NSString *sql = @"create table if not exists MovieDetailTable ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'title' TEXT, 'number' TEXT,'coverImgUrl' TEXT,'infoArray' TEXT,'screenshots' TEXT,'recommends' TEXT)";
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
        }
    }
    
    //影片详情增加磁力链接
    {
        if (![db columnExists:@"magnetic" inTableWithName:@"MovieDetailTable"]) {
            NSString *alertStr = @"ALTER TABLE MovieDetailTable ADD magnetic TEXT" ;
            [db executeUpdate:alertStr];
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
- (NSArray *)queryActressList:(NSInteger)pageSize {
    NSString *order = @"";
    if ([GlobalTool shareInstance].descOrder) {
        order = @"ORDER BY ID DESC";
    }
    NSInteger limitSize = LimitSize;
    NSString *sql = [NSString stringWithFormat:@"select * from 'ActressCollectionTable' %@ limit %ld offset %ld", order, limitSize, pageSize*limitSize];
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
    if (!isExsit) {
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
- (NSArray *)queryMovieList:(NSInteger)pageSize {
    NSString *order = @"";
    if ([GlobalTool shareInstance].descOrder) {
        order = @"ORDER BY ID DESC";
    }
    NSInteger limitSize = LimitSize;
    NSString *sql = [NSString stringWithFormat:@"select * from 'MovieCollectionTable' %@ limit %ld offset %ld", order, limitSize, pageSize*limitSize];
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
    if (!isExsit) {
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
- (NSArray *)queryMovieCacheList:(NSInteger)pageSize {
    NSString *order = @"";
    if ([GlobalTool shareInstance].descOrder) {
        order = @"ORDER BY ID DESC";
    }
    NSInteger limitSize = LimitSize;
    NSString *sql = [NSString stringWithFormat:@"select * from 'MovieCachedTable' %@ limit %ld offset %ld", order, limitSize, pageSize*limitSize];
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

/**
 插入电影详情数据
 */
- (BOOL)insertMovieDetail:(MovieDetailModel *)model {
    MovieListModel *listModel = [MovieListModel new];
    listModel.number = model.number;
    if ([self isMovieDetailExsit:listModel]) {
        return YES;
    }
    NSArray *categoryArr = model.infoArray;
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < categoryArr.count; i++) {
        
        NSDictionary *dict = categoryArr[i];
        NSString *title = dict.allKeys.firstObject;
        NSArray *items = [dict objectForKey:title];
        
        NSMutableArray *array = [NSMutableArray array];
        for (TitleLinkModel *item in items) {
            NSDictionary *itemDict = @{@"title":item.title,@"link":item.link,@"type":@(item.type)};
            [array addObject:itemDict];
        }
        [array1 addObject:@{title:[array copy]}];
    }
    NSString *categoryJson = [self objectToJson:array1];
    
    NSArray *screenshotsArr = model.screenshots;
    NSMutableArray *array2 = [NSMutableArray array];
    for (ScreenShotModel *model in screenshotsArr) {
        NSDictionary *itemDict = @{@"title":model.title,@"smallPicUrl":model.smallPicUrl,@"bigPicUrl":model.bigPicUrl};
        [array2 addObject:itemDict];
    }
    NSString *screenshotsJson = [self objectToJson:array2];
    
    NSArray *recommendArr = model.recommends;
    NSMutableArray *array3 = [NSMutableArray array];
    for (RecommendModel *model in recommendArr) {
        NSDictionary *itemDict = @{@"title":model.title,@"imgUrl":model.imgUrl,@"link":model.link};
        [array3 addObject:itemDict];
    }
    NSString *recommendJson = [self objectToJson:array3];
    
    NSArray *magneticArr = model.magneticArray;
    NSMutableArray *array4 = [NSMutableArray array];
    for (MagneticModel *model in magneticArr) {
        NSDictionary *itemDict = @{@"title":model.text,@"date":model.date,@"link":model.link, @"size": model.size, @"isHD": @(model.isHD)};
        [array4 addObject:itemDict];
    }
    NSString *magneticJson = [self objectToJson:array4];
    
    NSString *sql = [NSString stringWithFormat:@"insert into 'MovieDetailTable'(title,number,coverImgUrl,infoArray,screenshots,recommends,magnetic) values('%@','%@','%@','%@','%@','%@','%@')", model.title, model.number, model.coverImgUrl,categoryJson,screenshotsJson,recommendJson,magneticJson];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 更新电影详情数据
 */
- (BOOL)updateMovieDetail:(MovieDetailModel *)model {
    
    NSArray *categoryArr = model.infoArray;
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < categoryArr.count; i++) {
        
        NSDictionary *dict = categoryArr[i];
        NSString *title = dict.allKeys.firstObject;
        NSArray *items = [dict objectForKey:title];
        
        NSMutableArray *array = [NSMutableArray array];
        for (TitleLinkModel *item in items) {
            NSDictionary *itemDict = @{@"title":item.title,@"link":item.link,@"type":@(item.type)};
            [array addObject:itemDict];
        }
        [array1 addObject:@{title:[array copy]}];
    }
    NSString *categoryJson = [self objectToJson:array1];
    
    NSArray *screenshotsArr = model.screenshots;
    NSMutableArray *array2 = [NSMutableArray array];
    for (ScreenShotModel *model in screenshotsArr) {
        NSDictionary *itemDict = @{@"title":model.title,@"smallPicUrl":model.smallPicUrl,@"bigPicUrl":model.bigPicUrl};
        [array2 addObject:itemDict];
    }
    NSString *screenshotsJson = [self objectToJson:array2];
    
    NSArray *recommendArr = model.recommends;
    NSMutableArray *array3 = [NSMutableArray array];
    for (RecommendModel *model in recommendArr) {
        NSDictionary *itemDict = @{@"title":model.title,@"imgUrl":model.imgUrl,@"link":model.link};
        [array3 addObject:itemDict];
    }
    NSString *recommendJson = [self objectToJson:array3];
    
    NSArray *magneticArr = model.magneticArray;
    NSMutableArray *array4 = [NSMutableArray array];
    for (MagneticModel *model in magneticArr) {
        NSDictionary *itemDict = @{@"title":model.text,@"date":model.date,@"link":model.link, @"size": model.size, @"isHD": @(model.isHD)};
        [array4 addObject:itemDict];
    }
    NSString *magneticJson = [self objectToJson:array4];
    
    NSString *sql = [NSString stringWithFormat:@"update 'MovieDetailTable' set title='%@',coverImgUrl='%@',infoArray='%@',screenshots='%@',recommends='%@',magnetic='%@' where number='%@'", model.title, model.coverImgUrl,categoryJson,screenshotsJson,recommendJson,magneticJson,model.number];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 判断是否已存在电影详情
 */
- (BOOL)isMovieDetailExsit:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from MovieDetailTable where number='%@'", model.number];
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
 查询电影详情
 */
- (MovieDetailModel *)queryMovieDetail:(MovieListModel *)model {
    NSString *sql = [NSString stringWithFormat:@"select * from 'MovieDetailTable' where number='%@'", model.number];
    [self.db open];
    FMResultSet *result = [self.db executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        MovieDetailModel *model = [MovieDetailModel new];
        model.title = [result stringForColumn:@"title"];
        model.number = [result stringForColumn:@"number"];
        model.coverImgUrl = [result stringForColumn:@"coverImgUrl"];
        
        NSString *category = [result stringForColumn:@"infoArray"];
        NSArray *categoryArr = [self objectWithJsonString:category];
        NSMutableArray *array1 = [NSMutableArray array];
        for (NSDictionary *dict in categoryArr) {
            NSString *title = dict.allKeys.firstObject;
            NSArray *items = [dict objectForKey:title];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *itemDict in items) {
                TitleLinkModel *model = [TitleLinkModel new];
                model.title = itemDict[@"title"];
                model.link = itemDict[@"link"];
                model.type = [itemDict[@"type"] integerValue];
                [array addObject:model];
            }
            [array1 addObject:@{title:[array copy]}];
        }
        
        NSString *screenshots = [result stringForColumn:@"screenshots"];
        NSArray *screenshotsArr = [self objectWithJsonString:screenshots];
        NSMutableArray *array2 = [NSMutableArray array];
        for (NSDictionary *dict in screenshotsArr) {
            ScreenShotModel *model = [ScreenShotModel new];
            model.title = dict[@"title"];
            model.smallPicUrl = dict[@"smallPicUrl"];
            model.bigPicUrl = dict[@"bigPicUrl"];
            [array2 addObject:model];
        }
        
        NSString *recommends = [result stringForColumn:@"recommends"];
        NSArray *recommendsArr = [self objectWithJsonString:recommends];
        NSMutableArray *array3 = [NSMutableArray array];
        for (NSDictionary *dict in recommendsArr) {
            RecommendModel *model = [RecommendModel new];
            model.title = dict[@"title"];
            model.imgUrl = dict[@"imgUrl"];
            model.link = dict[@"link"];
            [array3 addObject:model];
        }
        
        NSString *magnetics = [result stringForColumn:@"magnetic"];
        NSArray *magneticsArr = [self objectWithJsonString:magnetics];
        NSMutableArray *array4 = [NSMutableArray array];
        for (NSDictionary *dict in magneticsArr) {
            MagneticModel *model = [MagneticModel new];
            model.text = dict[@"title"];
            model.date = dict[@"date"];
            model.link = dict[@"link"];
            model.size = dict[@"size"];
            model.isHD = [dict[@"isHD"] boolValue];
            [array4 addObject:model];
        }
        
        model.infoArray = [array1 copy];
        model.screenshots = [array2 copy];
        model.recommends = [array3 copy];
        model.magneticArray = [array4 copy];
        
        [arr addObject:model];
    }
    [self.db close];
    return arr.firstObject;
}

/**
 删除电影详情数据
 */
- (BOOL)deleteMovieDetail:(MovieDetailModel *)model {
    BOOL isExsit = [self isMovieDetailExsit:model];
    if (!isExsit) {
        return YES;
    }
    NSString *sql = [NSString stringWithFormat:@"delete from MovieDetailTable where number='%@'", model.number];
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

/**
 删除所有电影缓存数据
 */
- (BOOL)deleteAllCacheMovie {
    NSString *sql = @"delete from MovieCachedTable";
    BOOL result = [self baseUpdateSql:sql];
    return result;
}

@end
