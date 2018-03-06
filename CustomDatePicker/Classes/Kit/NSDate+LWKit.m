//
//  NSDate+LWKit.m
//  CustomDatePicker
//
//  Created by sunshinelww on 2018/3/5.
//

#import "NSDate+LWKit.h"

@implementation NSDate (LWKit)

- (NSInteger)year{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self];
}

- (NSInteger)day{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self];
}

- (NSInteger)hour{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:self];
}

- (NSInteger)minute{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:self];
}

@end
