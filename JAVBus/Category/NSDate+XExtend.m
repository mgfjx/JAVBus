//
//  NSDate+XExtend.m
//  Unity
//
//  Created by mgfjx on 2017/8/21.
//  Copyright © 2017年 XXL. All rights reserved.
//

#import "NSDate+XExtend.h"

@implementation NSDate (XExtend)

- (NSString*)getChineseMonth {
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"十一月", @"十二月", nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    
    return m_str;
    
}

@end
