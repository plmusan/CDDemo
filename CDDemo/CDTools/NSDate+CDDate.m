//
//  NSDate+CDDate.m
//  CDDemo
//
//  Created by x.wang on 15/5/29.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import "NSDate+CDDate.h"

@implementation NSDate (CDDate)

- (NSString *)stringWithFormatter:(NSString *)dateFormatter; {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:dateFormatter];
    return [f stringFromDate:self];
}

+ (NSTimeInterval)timeIntervalSince1970WithDateString:(NSString *)dateString dateFormatter:(NSString *)dateFormatter; {
    if (! dateString)
        return 0;
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:dateFormatter];
    NSDate *date = [f dateFromString:dateString];
    return date.timeIntervalSince1970;
}
+ (NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormatter:(NSString *)dateFormatter; {
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:dateFormatter];
    return [f stringFromDate:date];
}

@end
