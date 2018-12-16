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

static HtmlToJsonManager *instance ;

@interface HtmlToJsonManager ()

@property (nonatomic, strong) NSString *baseUrl ;

@end

@implementation HtmlToJsonManager

@synthesize baseUrl = _baseUrl;

- (NSString *)baseUrl {
    if (!_baseUrl) {
        _baseUrl = @"https://www.javbus.pw";
    }
    return _baseUrl;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HtmlToJsonManager alloc] init];
    });
    return instance;
}

- (void)startGetUrl:(NSString *)url success:(SuccessCallback)success failure:(FailCallback)failure {
    if (![url hasPrefix:@"http"]) {
        url = [NSString stringWithFormat:@"%@%@", self.baseUrl, url];
    }
    [HTTPMANAGER startGetUrl:url param:nil success:success failure:failure];
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
            NSLog(@"\n %@ \n %@ \n %@", imgUrl, name, link);
            
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

@end
