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

@end
