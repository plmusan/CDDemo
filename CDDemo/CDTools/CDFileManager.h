//
//  CDFile.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFileManager : NSObject

+ (instancetype)shareInstance;
- (void)moveFileFormPath:(NSString *)fromPath toPath:(NSString *)toPath __attribute((nonnull(1,2)));
- (void)moveFileFormPath:(NSString *)fromPath toPath:(NSString *)toPath excludeFile:(NSArray *)files __attribute((nonnull(1,2)));

@end

@interface CDFileManager (Tools)

+ (NSString *)homePath;
+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)tempPath;

+ (size_t)totalDiskSpace;
+ (size_t)freeDiskSpace;

+ (NSString *)stringWithSize:(size_t)size;

@end