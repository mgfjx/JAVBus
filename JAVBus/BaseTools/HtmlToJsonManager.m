//
//  HtmlToJsonManager.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "HtmlToJsonManager.h"
#import <Ono.h>
#import <TFHpple/TFHpple.h>

#import "ActressModel.h"
#import "MovieListModel.h"

static HtmlToJsonManager *instance ;

@interface HtmlToJsonManager ()

@end

@implementation HtmlToJsonManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HtmlToJsonManager alloc] init];
    });
    return instance;
}

- (void)startGetUrl:(NSString *)url success:(SuccessCallback)success failure:(FailCallback)failure {
    if (![url hasPrefix:@"http"]) {
        url = [NSString stringWithFormat:@"%@%@", [GlobalTool shareInstance].baseUrl, url];
    }
    [HTTPMANAGER startGetUrl:url param:nil success:success failure:failure];
}

- (void)testIp:(NSString *)ip callback:(void (^)(NSArray *array))callback {
    NSString *url = @"/actresses";
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *images  = [doc searchWithXPathQuery:@"//div[@class='photo-frame']"];
        NSArray *hrefs  = [doc searchWithXPathQuery:@"//a[@class='avatar-box text-center']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < images.count; i++) {
            
            TFHppleElement *e1 = images[i];
            
            TFHppleElement *imgElement = [e1 firstChildWithTagName:@"img"];
            
            TFHppleElement *href = hrefs[i];
            
            NSString *imgUrl = [imgElement objectForKey:@"src"];
            NSString *name = [imgElement objectForKey:@"title"];
            NSString *link = [href objectForKey:@"href"];
            
            ActressModel *model = [ActressModel new];
            model.avatarUrl = imgUrl;
            model.name = name;
            model.link = link;
            [array addObject:model];
        }
        
        if (callback) {
            callback([array copy]);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(nil);
        }
    }];
}

/**
 有码女优列表
 
 @param page 分页
 */
- (void)parseActressDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback  {
    
    NSString *url = @"/actresses";
    if (page > 1) {
        url = [NSString stringWithFormat:@"%@/%ld", url, page];
    }
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *images  = [doc searchWithXPathQuery:@"//div[@class='photo-frame']"];
        NSArray *hrefs  = [doc searchWithXPathQuery:@"//a[@class='avatar-box text-center']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < images.count; i++) {
            
            TFHppleElement *e1 = images[i];
            
            TFHppleElement *imgElement = [e1 firstChildWithTagName:@"img"];
            
            TFHppleElement *href = hrefs[i];
            
            NSString *imgUrl = [imgElement objectForKey:@"src"];
            NSString *name = [imgElement objectForKey:@"title"];
            NSString *link = [href objectForKey:@"href"];
//            NSLog(@"\n %@ \n %@ \n %@", imgUrl, name, link);
            
            ActressModel *model = [ActressModel new];
            model.avatarUrl = imgUrl;
            model.name = name;
            model.link = link;
            [array addObject:model];
        }
        
        if (callback) {
            callback([array copy]);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(nil);
        }
    }];
}

/**
 详情页

 @param page 分页
 */
- (void)parseActressDetailUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", page]];
    }
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *items = [doc searchWithXPathQuery:@"//a[@class='movie-box']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (TFHppleElement *elt in items) {
            NSString *link = [elt objectForKey:@"href"];
            TFHppleElement *e1 = [elt childrenWithClassName:@"photo-frame"].firstObject;
            TFHppleElement *e2 = [e1 firstChildWithTagName:@"img"];
            NSString *img = [e2 objectForKey:@"src"];
            NSString *title = [e2 objectForKey:@"title"];
            
            TFHppleElement *e3 = [elt childrenWithClassName:@"photo-info"].firstObject;
            TFHppleElement *e4 = [e3 firstChildWithTagName:@"span"];
            NSArray *arr = [e4 childrenWithTagName:@"date"];
            TFHppleElement *e5 = arr.firstObject;
            TFHppleElement *e6 = arr.lastObject;
            NSString *number = [e5 text];
            NSString *dateStr = [e6 text];
            
            NSLog(@"\n %@ \n %@ \n%@ \n%@ \n%@", img, title, link, number, dateStr);
            
            MovieListModel *model = [MovieListModel new];
            model.imgUrl = img;
            model.title = title;
            model.link = link;
            model.number = number;
            model.dateString = dateStr;
            [array addObject:model];
        }
        callback([array copy]);
    } failure:^(NSError *error) {
        callback(nil);
    }];
}

@end
