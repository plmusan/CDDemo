//
//  NSDate+CDDate.h
//  CDDemo
//
//  Created by x.wang on 15/5/29.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CDDate)

- (NSString *)stringWithFormatter:(NSString *)dateFormatter;

+ (NSTimeInterval)timeIntervalSince1970WithDateString:(NSString *)dateString dateFormatter:(NSString *)dateFormatter;
+ (NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormatter:(NSString *)dateFormatter;

@end
