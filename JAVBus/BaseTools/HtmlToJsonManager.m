//
//  HtmlToJsonManager.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "HtmlToJsonManager.h"
#import <TFHpple/TFHpple.h>

#import "ActressModel.h"
#import "MovieListModel.h"
#import "CategoryModel.h"
#import "TitleLinkModel.h"
#import "MovieDetailModel.h"
#import "ScreenShotModel.h"
#import "RecommendModel.h"
#import "MagneticModel.h"

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
    url = [NSString stringWithFormat:@"%@%@", ip, url];
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *objects  = [doc searchWithXPathQuery:@"//a[@class='avatar-box text-center']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < objects.count; i++) {
            
            TFHppleElement *e1 = objects[i];
            TFHppleElement *imgElement = [e1 searchWithXPathQuery:@"//div/img"].firstObject;
            TFHppleElement *e2 = [e1 searchWithXPathQuery:@"//div/span/button"].firstObject;
            
            NSString *imgUrl = [imgElement objectForKey:@"src"];
            NSString *name = [imgElement objectForKey:@"title"];
            NSString *link = [e1 objectForKey:@"href"];
//            NSLog(@"\n %@ \n %@ \n %@", imgUrl, name, link);
            
            ActressModel *model = [ActressModel new];
            model.avatarUrl = imgUrl;
            model.name = name;
            model.link = link;
            model.censoredString = e2.text;
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
 请求所有影片列表通用方法
 */
- (void)parseBaseListDataUrl:(NSString *)url callback:(void (^)(NSArray *array))callback {
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
            
//            NSLog(@"\n %@ \n %@ \n%@ \n%@ \n%@", img, title, link, number, dateStr);
            
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

/**
 请求女优列表通用
 */
- (void)parseBaseActorList:(NSString *)url callback:(void (^)(NSArray *array))callback {
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
            
            //替换某个字符
            NSString *baseUrl = [GlobalTool shareInstance].baseUrl;
            link = [link stringByReplacingOccurrencesOfString:baseUrl withString:@""];
            
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
 请求分类通用
 */
- (void)parseCategoryData:(NSString *)url callback:(void (^)(NSArray *array))callback {
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *titles  = [doc searchWithXPathQuery:@"//html/body/div[4]/h4"];
        NSArray *sections  = [doc searchWithXPathQuery:@"//div[@class='row genre-box']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < titles.count; i++) {
            
            TFHppleElement *e1 = titles[i];
            
            TFHppleElement *e2 = sections[i];
            NSArray *items = [e2 childrenWithTagName:@"a"];
            
            NSMutableArray *itemArray = [NSMutableArray array];
            for (TFHppleElement *el in items) {
                NSString *title = el.text;
                NSString *link = [el objectForKey:@"href"];
                CategoryItemModel *model = [CategoryItemModel new];
                model.title = title;
                model.link = link;
                [itemArray addObject:model];
            }
            
            CategoryModel *model = [CategoryModel new];
            model.title = e1.text;
            model.items = [itemArray copy];
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
 获取有码影片
 */
- (void)parseCensoredListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    NSString *url = @"";
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"/page/%ld", page]];
    }
    [self parseBaseListDataUrl:url callback:callback];
}

/**
 获取无码影片
 */
- (void)parseUncensoredListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    NSString *url = @"/uncensored";
    if (page > 1) {
        url = [NSString stringWithFormat:@"%@/page/%ld", url, page];
    }
    [self parseBaseListDataUrl:url callback:callback];
}

/**
 获取欧美影片
 */
- (void)parseXvdieoListDataByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    NSString *url = @"https://www.javbus.work";
    if (page > 1) {
        url = [NSString stringWithFormat:@"%@/page/%ld", url, page];
    }
    [self parseBaseListDataUrl:url callback:callback];
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
    [self parseBaseActorList:url callback:callback];
}

/**
 无码女优列表
 
 @param page 分页
 */
- (void)parseActressUncensoredListByPage:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    
    NSString *url = @"/uncensored/actresses";
    if (page > 1) {
        url = [NSString stringWithFormat:@"%@/%ld", url, page];
    }
    [self parseBaseActorList:url callback:callback];
}

/**
 女优详情列表页

 @param page 分页
 */
- (void)parseActressDetailUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array, ActressModel *model))callback {
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", page]];
    }
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        
        ActressModel *actor;
        {
            TFHppleElement *actorEle = [doc searchWithXPathQuery:@"//div[@class='avatar-box']"].firstObject;
            TFHppleElement *avatarEle = [actorEle searchWithXPathQuery:@"//div/img"].firstObject;
            NSString *avatarUrl = [avatarEle objectForKey:@"src"];
            NSString *name = [avatarEle objectForKey:@"title"];
            
            ActressModel *model = [ActressModel new];
            actor = model;
            model.name = name;
            model.avatarUrl = avatarUrl;
            
            NSArray *infoArray = [actorEle searchWithXPathQuery:@"//div/p"];
            NSMutableArray *array = [NSMutableArray array];
            for (TFHppleElement *ele in infoArray) {
                [array addObject:ele.text];
            }
            model.infoArray = [array copy];
        }
        
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
            
            //            NSLog(@"\n %@ \n %@ \n%@ \n%@ \n%@", img, title, link, number, dateStr);
            
            MovieListModel *model = [MovieListModel new];
            model.imgUrl = img;
            model.title = title;
            model.link = link;
            model.number = number;
            model.dateString = dateStr;
            [array addObject:model];
        }
        callback([array copy], actor);
    } failure:^(NSError *error) {
        callback(nil, nil);
    }];
}

/**
 请求有码类别
 */
- (void)parseCensoredCategoryListCallback:(void (^)(NSArray *array))callback {
    NSString *url = @"/genre";
    [self parseCategoryData:url callback:callback];
}

/**
 请求无码类别
 */
- (void)parseUnCensoredCategoryListCallback:(void (^)(NSArray *array))callback {
    NSString *url = @"/uncensored/genre";
    [self parseCategoryData:url callback:callback];
}

/**
 类别详情
 */
- (void)parseCategoryListUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", page]];
    }
    [self parseBaseListDataUrl:url callback:callback];
}

/**
 获取movie详情
 */
- (void)parseMovieDetailByUrl:(NSString *)url
               detailCallback:(void (^)(MovieDetailModel *model))detailCallback
             magneticCallback:(void (^)(NSArray *magneticList))magneticCallback {
    url = url.length == 0 ? @"" : url;
    [self startGetUrl:url success:^(id resultDict) {
        
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *images = [doc searchWithXPathQuery:@"//a[@class='bigImage']"];
        NSString *imgUrl = [images.firstObject objectForKey:@"href"];
        
        //页面静态信息
        NSArray *movieInfoArray = [doc searchWithXPathQuery:@"//html/body/div[5]/div[1]/div[2]/p"];
        NSInteger index = 0;
        NSMutableArray *array = [NSMutableArray array];
        for (TFHppleElement *ele in movieInfoArray) {
            NSArray *spans = [ele searchWithXPathQuery:@"//span"];
            TFHppleElement *e1 = spans.firstObject;
            NSString *title = e1.text;
            NSString *content ;
            NSString *link ;
            LinkType type  = LinkTypeNone;
            
            if ([title isEqualToString:@"識別碼:"]) {
                TFHppleElement *e2 = spans.lastObject;
                content = e2.text;
                type = LinkTypeNumber;
            }else if ([title isEqualToString:@"發行日期:"] || [title isEqualToString:@"長度:"]){
                content = ele.text;
            }else if ([title isEqualToString:@"製作商:"]) {
                TFHppleElement *e = [ele searchWithXPathQuery:@"//a"].firstObject;
                content = e.text;
                link = [e objectForKey:@"href"];
                type = LinkTypeNormal;
            }else if ([title isEqualToString:@"發行商:"]) {
                TFHppleElement *e = [ele searchWithXPathQuery:@"//a"].firstObject;
                content = e.text;
                link = [e objectForKey:@"href"];
                type = LinkTypeNormal;
            }else if ([title isEqualToString:@"演員:"]) {
                
            }else if ([title isEqualToString:@"導演:"]) {
                TFHppleElement *e = [ele searchWithXPathQuery:@"//a"].firstObject;
                content = e.text;
                link = [e objectForKey:@"href"];
                type = LinkTypeNormal;
            }else if ([title isEqualToString:@"系列:"]) {
                TFHppleElement *e = [ele searchWithXPathQuery:@"//a"].firstObject;
                content = e.text;
                link = [e objectForKey:@"href"];
                type = LinkTypeNormal;
            }else if ([title isEqualToString:@"識別碼:"]) {
                
            }
            
            if ([ele.text isEqualToString:@"類別:"]) {
                index = [movieInfoArray indexOfObject:ele];
            }
            
            if (content.length == 0) {
                continue;
            }
            
            TitleLinkModel *model = [TitleLinkModel new];
            model.title = content;
            model.link = link;
            model.type = type;
            [array addObject:@{title:@[model]}];
            NSLog(@"title: %@, content: %@, link: %@", title, content, link);
        }
        
        //类别
        TFHppleElement *ce = movieInfoArray[index+1];
        NSArray *categorys = [ce searchWithXPathQuery:@"//span[@class='genre']"];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (TFHppleElement *ele in categorys) {
            TFHppleElement *e = [ele childrenWithTagName:@"a"].firstObject;
            TitleLinkModel *model = [TitleLinkModel new];
            model.title = e.text;
            model.link = [e objectForKey:@"href"];
            model.type = LinkTypeCategory;
            [arr1 addObject:model];
            NSLog(@"类别: %@", e.text);
        }
        if (arr1.count > 0) {
            [array addObject:@{@"類別:":[arr1 copy]}];
        }
        
        //演员
        NSArray *actors = [doc searchWithXPathQuery:@"//div[@class='star-name']"];
        NSMutableArray *arr2 = [NSMutableArray array];
        for (TFHppleElement *ele in actors) {
            TFHppleElement *e = [ele childrenWithTagName:@"a"].firstObject;
            TitleLinkModel *model = [TitleLinkModel new];
            model.title = e.text;
            NSString *link = [e objectForKey:@"href"];
            //替换某个字符
            NSString *baseUrl = [GlobalTool shareInstance].baseUrl;
            link = [link stringByReplacingOccurrencesOfString:baseUrl withString:@""];
            model.link = link;
            model.type = LinkTypeActor;
            [arr2 addObject:model];
            NSLog(@"演员: %@", [e objectForKey:@"title"]);
        }
        if (arr2.count > 0) {
            [array addObject:@{@"演員":[arr2 copy]}];
        }
        
        //截图
        NSArray *screenshots = [doc searchWithXPathQuery:@"///a[@class='sample-box']"];
        NSMutableArray *ssArr = [NSMutableArray array];
        for (TFHppleElement *ele in screenshots) {
            ScreenShotModel *model = [ScreenShotModel new];
            model.bigPicUrl = [ele objectForKey:@"href"];
            
            TFHppleElement *subEle = [ele searchWithXPathQuery:@"//div/img"].firstObject;
            model.smallPicUrl = [subEle objectForKey:@"src"];
            model.title = [subEle objectForKey:@"title"];
            [ssArr addObject:model];
        }
        
        //推荐 //*[@id="related-waterfall"]/a
        NSArray *recommends = [doc searchWithXPathQuery:@"//*[@id='related-waterfall']/a"];
        NSMutableArray *array3 = [NSMutableArray array];
        for (TFHppleElement *ele in recommends) {
            RecommendModel *model = [RecommendModel new];
            model.title = [ele objectForKey:@"title"];
            model.link = [ele objectForKey:@"href"];
            TFHppleElement *subEle = [ele searchWithXPathQuery:@"//div/img"].firstObject;
            model.imgUrl = [subEle objectForKey:@"src"];
            [array3 addObject:model];
        }
        
        MovieDetailModel *detail = [MovieDetailModel new];
        detail.coverImgUrl = imgUrl;
        detail.infoArray = [array copy];
        detail.screenshots = [ssArr copy];
        detail.recommends = [array3 copy];
        
        if (detailCallback) {
            detailCallback(detail);
        }
        
        //请求磁力链接动态内容
        NSArray *paramsArr = [doc searchWithXPathQuery:@"//html/body/script[3]/text()"];
        if (paramsArr.count > 0) {
            TFHppleElement *ele = paramsArr.firstObject;
            NSString *string = ele.content;
            NSString *temp = [string clearSpecialCharacter];
            
            NSArray *array = [temp componentsSeparatedByString:@";"];
            if (array.count >= 3) {
                NSString *gid = [(NSString *)array[0] componentsSeparatedByString:@"="].lastObject;
                NSString *uc = [(NSString *)array[1] componentsSeparatedByString:@"="].lastObject;
                NSString *img = [(NSString *)array[2] componentsSeparatedByString:@"="].lastObject;
                img = [img stringByReplacingOccurrencesOfString:@"'" withString:@""];
                NSString *floor = [@(arc4random()%899 + 100) stringValue];
                NSString *shortUrl = [NSString stringWithFormat:@"/ajax/uncledatoolsbyajax.php?gid=%@&lang=zh&img=%@&uc=%@&floor=%@", gid, img, uc, floor];
                
                [self startGetUrl:shortUrl success:^(id resultDict) {
                    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:resultDict];
                    NSArray *links = [doc searchWithXPathQuery:@"//tr"];
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (TFHppleElement *ele in links) {
                        NSArray *tdArray = [ele childrenWithTagName:@"td"];
                        if (tdArray.count < 3) {
                            continue;
                        }
                        
                        MagneticModel *model = [MagneticModel new];
                        
                        TFHppleElement *linkEle = tdArray[0];
                        TFHppleElement *sizeEle = tdArray[1];
                        TFHppleElement *dateEle = tdArray[2];
                        
                        NSArray *alinkArray = [linkEle childrenWithTagName:@"a"];
                        TFHppleElement *linkA = alinkArray.firstObject;
                        NSString *href = [linkA objectForKey:@"href"];
                        NSString *title = [linkA text];
                        model.link = [href clearSpecialCharacter];
                        model.text = [title clearSpecialCharacter];
                        
                        TFHppleElement *hdA = alinkArray.lastObject;
                        if (linkA != hdA) {
                            //显示高清
                            model.isHD = YES;
                        }else{
                            model.isHD = NO;
                        }
                        TFHppleElement *sizeA = [sizeEle childrenWithTagName:@"a"].firstObject;
                        TFHppleElement *dateA = [dateEle childrenWithTagName:@"a"].firstObject;
                        NSString *sizeString = [[sizeA text] clearSpecialCharacter];
                        NSString *dateString = [[dateA text] clearSpecialCharacter];
                        
                        model.size = sizeString;
                        model.date = dateString;
                        
                        [array addObject:model];
                    }
                    if (magneticCallback) {
                        magneticCallback([array copy]);
                    }
                    
                } failure:^(NSError *error) {
                    NSLog(@"%@", error);
                    if (magneticCallback) {
                        magneticCallback(@[]);
                    }
                }];
            }
        }
        
    } failure:^(NSError *error) {
        if (detailCallback) {
            detailCallback(nil);
        }
        if (magneticCallback) {
            magneticCallback(@[]);
        }
    }];
}


/**
 搜索影片
 */
- (void)parseSearchListByUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"/%ld", page]];
    }
    [self parseBaseListDataUrl:url callback:callback];
}

/**
 搜索演员
 */
- (void)parseSearchActorListByUrl:(NSString *)url page:(NSInteger)page callback:(void (^)(NSArray *array))callback {
    if (page > 1) {
        url = [url stringByAppendingPathComponent:[NSString stringWithFormat:@"/%ld", page]];
    }
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *objects  = [doc searchWithXPathQuery:@"//a[@class='avatar-box text-center']"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < objects.count; i++) {
            
            TFHppleElement *e1 = objects[i];
            TFHppleElement *imgElement = [e1 searchWithXPathQuery:@"//div/img"].firstObject;
            TFHppleElement *e2 = [e1 searchWithXPathQuery:@"//div/span/button"].firstObject;
            
            NSString *imgUrl = [imgElement objectForKey:@"src"];
            NSString *name = [imgElement objectForKey:@"title"];
            NSString *link = [e1 objectForKey:@"href"];
//            NSLog(@"\n %@ \n %@ \n %@", imgUrl, name, link);
            
            ActressModel *model = [ActressModel new];
            model.avatarUrl = imgUrl;
            model.name = name;
            model.link = link;
            model.censoredString = e2.text;
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
 解析论坛首页数据
 */
- (void)parseForumHomeDataCallback:(void (^)(NSArray *array))callback {
    NSString *url = @"https://avgle.com/video/MywvmvMUgvf/%E6%B3%A2%E5%A4%9A%E9%87%8E%E7%B5%90%E8%A1%A3-7%E6%9C%AC%E7%95%AA-4%E6%99%82%E9%96%93-xvsr-442-1";
    [self startGetUrl:url success:^(id resultDict) {
        TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:resultDict];
        NSArray *images  = [doc searchWithXPathQuery:@"//html"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        if (callback) {
            callback([array copy]);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(nil);
        }
    }];
}



@end
