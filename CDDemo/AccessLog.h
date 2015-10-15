//
//  AccessLog.h
//  ActiBook Docs
//
//  Created by x.wang on 15/5/29.
//  Copyright (c) 2015年 startiasoft inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessLog : NSObject

@property (nonatomic, strong) NSMutableArray *logInfo;

- (instancetype)initWithLogInfo:(NSMutableArray *)logInfo;

- (NSString *)JSONStringWithLogInfo;

@end


@interface LogInfo : NSObject

@property (nonatomic) NSInteger domainNum;

@property (nonatomic) NSInteger memberNum;
@property (nonatomic, strong) NSString *memberName;

@property (nonatomic) NSInteger contentNum;
@property (nonatomic, strong) NSString *contentTitle;
@property (nonatomic, strong) NSString *terminalType;
@property (nonatomic, strong) NSString *accessDate;

- (instancetype)initWithDomainNum:(NSInteger)domainNum
                        memberNum:(NSInteger)memberNum
                       memberName:(NSString *)memberName
                       contentNum:(NSInteger)contentNum
                     contentTitle:(NSString *)contentTitle
                       accessDate:(NSString *)accessDate;

@end

#ifndef ACCESS_DATE_FORMAT
#define ACCESS_DATE_FORMAT @"yyyy/MM/dd HH:mm:ss"
#endif
FOUNDATION_EXPORT NSString *AccessDate();
@interface AccessLog (Tools)

+ (NSString *)accessDateWithDate:(NSDate *)date;
+ (NSTimeInterval)timeIntervalSince1970WithDateString:(NSString *)dateString;
+ (NSString *)accessDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

@end
