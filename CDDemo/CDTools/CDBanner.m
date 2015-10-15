//
//  CDBanner.m
//  CDDemo
//
//  Created by x.wang on 15/4/28.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDBanner.h"

static NSString *MSG = @"msg";
static NSString *CON = @"controller";
static NSString *DIR = @"direction";

NSString *BannerDirectionString(BannerDirection direction) {
    switch (direction) {
        case BannerDirectionTop:
            return @"BannerDirectionTop";
        case BannerDirectionBottom:
            return @"BannerDirectionBottom";
    }
}

@interface CDBanner ()

@property (nonatomic, strong) UIView *banner;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *bannerQueue;
@property (nonatomic) BannerDirection direction;
@property (nonatomic, weak) UIViewController *superController;

@end

@implementation CDBanner

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 2.0;
        self.bannerHeight = 80.0;
        self.bannerBackgroung = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
        self.bannerQueue = [NSMutableArray array];
        self.borderWidth = 1.0;
        if (! [UIDevice currentDevice].isGeneratingDeviceOrientationNotifications)
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotated:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotated:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willRotated:(NSNotification *)aNotification; {
    if (self.banner) {
        [self.banner removeFromSuperview];
    }
}

- (void)didRotated:(NSNotification *)aNotification; {
    if (self.banner) {
        CGFloat width = self.superController.view.frame.size.width;
        CGRect bf = self.banner.frame;
        self.banner.frame = CGRectMake(bf.origin.x, bf.origin.y, width, bf.size.height);
        self.label.center = self.banner.center;
        [self.banner layoutSubviews];
        [self.superController.view addSubview:self.banner];
    }
}

- (void)showBannerTop:(UIViewController *)controller {
    CGSize size = self.banner.frame.size;
    self.banner.frame = CGRectMake(0, -1 * size.height, size.width, size.height);
    [controller.view addSubview:self.banner];
    [UIView animateWithDuration:0.5 animations:^{
        self.banner.frame = CGRectMake(0, 0, size.width, size.height);
    }];
}

- (void)showBannerBottom:(UIViewController *)controller {
    CGSize size = self.banner.frame.size;
    self.banner.frame = CGRectMake(0, controller.view.frame.size.height, size.width, size.height);
    [controller.view addSubview:self.banner];
    [UIView animateWithDuration:0.5 animations:^{
        self.banner.frame = CGRectMake(0, controller.view.frame.size.height - size.height, size.width, size.height);
    }];
}

- (void)showBanner:(NSString *)msg inController:(UIViewController *)controller direction:(BannerDirection)direction; {
    if (self.banner) {
        NSDictionary *dic = @{MSG:msg,CON:controller,DIR:@(direction)};
        [self.bannerQueue addObject:dic];
        return;
    }
    self.superController = controller;
    [self initBannerWithSuperView:self.superController.view msg:msg];
    self.direction = direction;
    switch (self.direction) {
        case BannerDirectionTop:
            [self showBannerTop:controller];
            break;
            
        case BannerDirectionBottom:
            [self showBannerBottom:controller];
            break;
    }
    [self performSelector:@selector(removeShowingBannerWithAnimation) withObject:nil afterDelay:self.duration];
}

- (void)initBannerWithSuperView:(UIView *)superView msg:(NSString *)msg {
    CGSize size = superView.frame.size;
    self.banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, self.bannerHeight)];
    if (self.borderColor) {
        self.banner.layer.borderColor = self.borderColor.CGColor;
        self.banner.layer.borderWidth = self.borderWidth;
    }
    self.banner.backgroundColor = self.bannerBackgroung;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width - 20, self.bannerHeight - 20)];
    self.label.text = msg;
    self.label.textColor = self.textColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 10;
    self.label.center = self.banner.center;
    [self.banner addSubview:self.label];
}

- (void)removeShowingBannerWithAnimation; {
    [UIView animateWithDuration:0.5 animations:^{
        CGSize size = self.banner.frame.size;
        CGPoint origin = self.banner.frame.origin;
        switch (self.direction) {
            case BannerDirectionTop:
                self.banner.frame = CGRectMake(0, -1 * size.height, size.width, size.height);
                break;
            case BannerDirectionBottom:
                self.banner.frame = CGRectMake(0, origin.y + size.height, size.width, size.height);
                break;
        }
    } completion:^(BOOL finished) {
        [self.banner removeFromSuperview];
        self.banner = nil;
        [self showNext];
    }];
}

- (void)showNext {
    if (self.bannerQueue.count > 0) {
        NSDictionary *dic = self.bannerQueue.firstObject;
        NSString *msg = [dic objectForKey:MSG];
        id controller = [dic objectForKey:CON];
        NSNumber *dir = [dic objectForKey:DIR];
        [self.bannerQueue removeObjectAtIndex:0];
        [self showBanner:msg inController:controller direction:dir.integerValue];
    }
}

@end
