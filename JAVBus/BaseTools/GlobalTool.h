//
//  GlobalTool.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/22.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalTool : NSObject

SingletonDeclare(Instance)

/**
 列数
 */
@property (nonatomic, assign) NSUInteger columnNum ;

@property (nonatomic, strong) NSString *baseUrl ;

/**
 可用ip地址
 */
@property (nonatomic, strong) NSArray *ips ;

/**
 影片预览文件夹
 */
@property (nonatomic, strong, readonly) NSString *movieCacheDir ;

/**
 是否降序
 */
@property (nonatomic, assign) BOOL descOrder ;

/// 是否显示含有磁力链接的影片，否为显示全部影片
@property (nonatomic, assign) BOOL showHasMag ;

@end
