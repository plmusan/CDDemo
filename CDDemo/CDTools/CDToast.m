//
//  CDTost.m
//  CDDemo
//
//  Created by x.wang on 15/4/28.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDToast.h"

#define TOTAL_HORIZONTAL_MARGINS 100.0
#define BOTTOM_MARGINS 100.0

const CGFloat DefaultToastTime = 1.0;

void Toast(NSString *msg) {
    [[CDToast shareInstance] showMessage:msg after:DefaultToastTime];
}

void Toast_f(NSString *msg, CGFloat time) {
    time = time < 1.0 ? 1.0 : time;
    [[CDToast shareInstance] showMessage:msg after:time];
}

UIKIT_STATIC_INLINE UIView *superView() {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

UIKIT_STATIC_INLINE CGFloat MaxWidth() {
    return (superView().frame.size.width - TOTAL_HORIZONTAL_MARGINS) ;
}

UIKIT_STATIC_INLINE CGFloat MaxHeight() {
    return (superView().frame.size.height / 2 - BOTTOM_MARGINS);
}

@interface CDToast ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic) BOOL isShowMsg;
@property (strong) NSMutableArray *msgArr;
@property (nonatomic, strong) CDToastConfigure *config;

@end

@implementation CDToast

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setToastConfigure:(CDToastConfigure *)conf; {
    self.config = conf;
}

- (instancetype)init {
    if (self = [super init]) {
        self.msgArr = [NSMutableArray array];
        self.config = [CDToastConfigure defaultToastConfigure];
        if (! [UIDevice currentDevice].isGeneratingDeviceOrientationNotifications)
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRotated:)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willRotated:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willRotated:(NSNotification *)aNotification; {
    if (self.isShowMsg) {
        [self.label removeFromSuperview];
    }
}

- (void)didRotated:(NSNotification *)aNotification; {
    if (self.isShowMsg) {
        [self configLabelWithMsg:self.msg];
        [superView() addSubview:self.label];
        self.label.center = CGPointMake(superView().center.x, superView().center.y + MaxHeight());
    }
}

- (CGFloat)widthWithMsg:(NSString *)msg {
    CGSize constraint = CGSizeMake(MAXFLOAT, 0.0);
    NSDictionary *dic = @{NSFontAttributeName :self.config.font};
    CGRect frame = [msg boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic context:nil];
    return frame.size.width;
}

- (CGFloat)oneWorldHeight {
    CGSize constraint = CGSizeMake(0.0, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName :self.config.font};
    CGRect frame = [@"oneWorldHeight" boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic context:nil];
    return frame.size.height;
}

- (void)configLabelWithMsg:(NSString *)msg {
    CGFloat msgWidth = [self widthWithMsg:msg];
    NSInteger lineNum = ( msgWidth / MaxWidth() ) + 1;
    CGFloat labelWidth = msgWidth + 16 < MaxWidth() ? msgWidth + 16 : MaxWidth();
    self.label.frame = CGRectMake(0, 0, labelWidth, lineNum * [self oneWorldHeight] + 16);
    self.label.text = msg;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = lineNum;
    self.label.backgroundColor = self.config.backgroundColor;
    self.label.textColor = self.config.textColor;
    self.label.font = self.config.font;
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = self.config.cornerRadius;
}

- (void)addLabelWithMsg:(NSString *)msg {
    self.isShowMsg = YES;
    self.msg = msg;
    self.label = [[UILabel alloc] init];
    [self configLabelWithMsg:msg];
    [superView() addSubview:self.label];
    self.label.center = CGPointMake(superView().center.x, superView().center.y + MaxHeight());
    self.label.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.label.alpha = 1;
    } completion:nil];
}

- (void)removeLabel {
    if (self.label) {
        [UIView animateWithDuration:0.5 animations:^{
            self.label.alpha = 0;
        } completion:^(BOOL finished) {
            [self.label removeFromSuperview];
            self.label = nil;
            self.isShowMsg = NO;
            [self showNext];
        }];
    }
}

- (void)showNext {
    if (self.msgArr.count > 0) {
        NSDictionary *dic = self.msgArr.firstObject;
        NSString *msg = dic.allKeys.firstObject;
        NSNumber *time = dic.allValues.firstObject;
        [self.msgArr removeObjectAtIndex:0];
        [self showMessage:msg after:time.floatValue];
    }
}

- (void)showMessage:(NSString *)msg after:(CGFloat)time {
    time = time < 0.0 ? 0.0 : time;
    if (self.isShowMsg) {
        NSDictionary *dic = @{msg:@(time)};
        [self.msgArr addObject:dic];
        return;
    }
    [self addLabelWithMsg:msg];
    [self performSelector:@selector(removeLabel) withObject:nil afterDelay:time];
}

@end


@implementation CDToastConfigure

+ (CDToastConfigure *)defaultToastConfigure {
    CDToastConfigure *conf = [[self alloc] init];
    if (conf) {
        conf.backgroundColor = [UIColor blackColor];
        conf.textColor = [UIColor whiteColor];
        conf.font = [UIFont systemFontOfSize:17.0];
    }
    return conf;
}


@end

