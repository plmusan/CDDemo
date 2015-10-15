//
//  CDFile.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDFileManager.h"

NSString *const FSFromPath = @"fs_from_path";
NSString *const FSToPath = @"fs_to_path";
NSString *const FSExclude = @"fs_exclude";

@interface CDFileManager ()

@property BOOL isMoveFile;
@property (nonatomic, strong) NSMutableArray *waitForMove;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation CDFileManager

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.waitForMove = [NSMutableArray array];
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (void)moveFileFormPath:(NSString *)fromPath toPath:(NSString *)toPath {
    [self moveFileFormPath:fromPath toPath:toPath excludeFile:nil];
}

- (void)moveFileFormPath:(NSString *)fromPath toPath:(NSString *)toPath excludeFile:(NSArray *)files {
    if (self.isMoveFile) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{FSFromPath:fromPath, FSToPath:toPath}];
        if (files) [dic setObject:files forKey:FSExclude];
        [self.waitForMove addObject:dic];
        return;
    }
    [self fs_willBegin];
    [self fs_startMove:fromPath :toPath :files];
    [self fs_didFinished];
}

- (void)fs_startMove:(NSString *)from :(NSString *)to :(NSArray *)files {
    NSError *error = nil;
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:from error:&error];
    if (error) {
        [self fs_error:error];
    }
    for(NSString *sourceFileName in contents) {
        if ([files containsObject:sourceFileName]) continue;
        NSString *sourceFile = [from stringByAppendingPathComponent:sourceFileName];
        NSString *destFile = [to stringByAppendingPathComponent:sourceFileName];
        if(![self.fileManager moveItemAtPath:sourceFile toPath:destFile error:&error]) {
            [self fs_error:error];
            error = nil;
        }
    }
}

- (void)nextStart; {
    if (self.waitForMove.count > 0) {
        NSDictionary *dic = self.waitForMove.firstObject;
        NSString *from = [dic objectForKey:FSFromPath];
        NSString *to = [dic objectForKey:FSToPath];
        NSArray *ex = [dic objectForKey:FSExclude];
        [self.waitForMove removeObject:dic];
        [self moveFileFormPath:from toPath:to excludeFile:ex];
    }
}

- (void)fs_willBegin{
    self.isMoveFile = YES;
}

- (void)fs_didFinished{
    self.isMoveFile = NO;
    [self nextStart];
}

- (void)fs_error:(NSError *)error {
    NSLog(@"error %@", error);
}

@end

@implementation CDFileManager (Tools)

+ (NSString *)homePath{
    return NSHomeDirectory();
}

+ (NSString *)documentPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)cachePath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)tempPath{
    return NSTemporaryDirectory();
}

+ (size_t)totalDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *size = [fattributes objectForKey:NSFileSystemSize];
    return size.unsignedLongLongValue;
}

+ (size_t)freeDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *size = [fattributes objectForKey:NSFileSystemFreeSize];
    return size.unsignedLongLongValue;
}

+ (NSString *)stringWithSize:(size_t)size {
    NSString *result = @"";
    if (size < 1024) {
        result = [NSString stringWithFormat:@"%zuB", size];
    } else if (size < 1024 * 1024) {
        result = [NSString stringWithFormat:@"%.1fKB", (size / (1024.0))];
    } else if (size < 1024 * 1024 *1024) {
        result = [NSString stringWithFormat:@"%.1fMB", (size / (1024.0 * 1024))];
    } else if (size < 1024.0 * 1024 * 1024 * 1024) {
        result = [NSString stringWithFormat:@"%.1fGB", (size / (1024.0 * 1024 * 1024))];
    } else {
        result = [NSString stringWithFormat:@"%.1fTB", (size / 1024.0 * 1024 * 1024 * 1024)];
    }
    return result;
}

@end
