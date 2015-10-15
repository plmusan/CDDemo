//
//  AccessLog.m
//  ActiBook Docs
//
//  Created by x.wang on 15/5/29.
//  Copyright (c) 2015年 startiasoft inc. All rights reserved.
//

#import "AccessLog.h"

@implementation AccessLog

- (instancetype)initWithLogInfo:(NSMutableArray *)logInfo; {
    if (self = [super init]) {
        if (! logInfo) logInfo = [NSMutableArray array];
        self.logInfo = logInfo;
    }
    return self;
}

- (NSString *)JSONStringWithLogInfo {
    NSMutableString *result = [NSMutableString stringWithString:@"{\"accessLogInfo\":["];
    for (LogInfo *info in self.logInfo) {
        [result appendString:@"{"];
        [result appendString:[NSString stringWithFormat:@"\"domainNum\":%ld,",(long)info.domainNum]];
        [result appendString:[NSString stringWithFormat:@"\"contentNum\":%ld,",(long)info.contentNum]];
        [result appendString:[NSString stringWithFormat:@"\"contentTitle\":\"%@\",",info.contentTitle]];
        [result appendString:[NSString stringWithFormat:@"\"memberNum\":%ld,",(long)info.memberNum]];
        [result appendString:[NSString stringWithFormat:@"\"memberName\":\"%@\",",info.memberName]];
        [result appendString:[NSString stringWithFormat:@"\"terminalType\":\"%@\",",info.terminalType]];
        [result appendString:[NSString stringWithFormat:@"\"accessDate\":\"%@\"",info.accessDate]];
        [result appendString:@"},"];
    }
    if (self.logInfo.count > 0) {
        NSRange range = NSMakeRange(result.length - 1, 1);
        [result deleteCharactersInRange:range];
    }
    [result appendString:@"]}"];
    return [NSString stringWithString:result];
}

@end


@implementation LogInfo

- (instancetype)initWithDomainNum:(NSInteger)domainNum
                        memberNum:(NSInteger)memberNum
                       memberName:(NSString *)memberName
                       contentNum:(NSInteger)contentNum
                     contentTitle:(NSString *)contentTitle
                       accessDate:(NSString *)accessDate;{
    if (self = [super init]) {
        self.domainNum = domainNum;
        self.memberNum = memberNum;
        self.memberName = memberName;
        self.contentNum = contentNum;
        self.contentTitle = contentTitle;
        self.terminalType = @"ios";
        self.accessDate = accessDate;
    }
    return self;
}

@end

@implementation AccessLog (Tools)

+ (NSString *)accessDateWithDate:(NSDate *)date; {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:ACCESS_DATE_FORMAT];
    return [f stringFromDate:date];
}

+ (NSTimeInterval)timeIntervalSince1970WithDateString:(NSString *)dateString; {
    if (dateString)
        return 0;
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:ACCESS_DATE_FORMAT];
    NSDate *date = [f dateFromString:dateString];
    return date.timeIntervalSince1970;
}

+ (NSString *)accessDateStringWithTimeInterval:(NSTimeInterval)timeInterval; {
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:ACCESS_DATE_FORMAT];
    return [f stringFromDate:date];
}

@end

NSString *AccessDate() {
    NSDate *date = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:ACCESS_DATE_FORMAT];
    return [f stringFromDate:date];
}

