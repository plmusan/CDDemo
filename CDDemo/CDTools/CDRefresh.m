//
//  CDRefresh.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDRefresh.h"

static const CGFloat RefreshHeight = 44.0;

@interface CDRefresh ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) UIActivityIndicatorView *topActivity;
@property (nonatomic, strong) UIActivityIndicatorView *bottomActivity;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic) BOOL isWorking;
@property (nonatomic) RefreshType refreshType;

@end

@implementation CDRefresh

- (instancetype)initWithScrollView:(UIScrollView *)scrollView; {
    if (self = [super init]) {
        self.scrollView = scrollView;
        self.canLoadMore = YES;
        self.canRefresh = YES;
        [self instanceProperty];
        [self addObserver:self forKeyPath:@"scrollView" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        if (! [UIDevice currentDevice].isGeneratingDeviceOrientationNotifications)
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotated:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotated:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)willRotated:(NSNotification *)aNotification; {
//    if (self.refreshType == RefreshTypeLoading) {
//        [self.bottomView removeFromSuperview];
//    } else if (self.refreshType == RefreshTypeRefreshing) {
//        [self.topView removeFromSuperview];
//    }
}

- (void)didRotated:(NSNotification *)aNotification; {
//    if (! self.isWorking) return;
//    CGFloat width = self.scrollView.frame.size.width;
//    CGFloat height = self.scrollView.contentSize.height;
//    
//    self.bottomView.frame = CGRectMake(0, height, width, RefreshHeight);
//    self.bottomActivity.center = self.bottomView.center;
//    
//    self.topView.frame = CGRectMake(0, 0, width, RefreshHeight);
//    self.topActivity.center = self.topView.center;
//    
//    if (self.refreshType == RefreshTypeLoading) {
//        [self.scrollView addSubview:self.bottomView];
//    } else if (self.refreshType == RefreshTypeRefreshing) {
//        [self.scrollView addSubview:self.topView];
//    }
}

- (void)instanceProperty {
    self.topActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.bottomActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.contentSize.height;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -1 * RefreshHeight, width, RefreshHeight)];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, RefreshHeight)];
    
    [self.topView addSubview:self.topActivity];
    [self.bottomView addSubview:self.bottomActivity];
    
    self.topActivity.center = self.topView.center;
    self.bottomActivity.center = self.bottomView.center;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"scrollView"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addRefreshView {
    if (! [self.scrollView.subviews containsObject:self.topView]) {
        [self.scrollView addSubview:self.topView];
        [self.topActivity startAnimating];
    }
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat currentPostion = self.scrollView.contentOffset.y;
    self.topView.frame = CGRectMake(0, 0, width, -1 * currentPostion);
}

- (void)addLoadMoreView {
    if (! [self.scrollView.subviews containsObject:self.bottomView]) {
        [self.scrollView addSubview:self.bottomView];
        [self.bottomActivity startAnimating];
    }
    
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.contentSize.height;
    CGFloat currentPostion = self.scrollView.contentOffset.y;
    CGFloat scrollFrameHeight = self.scrollView.frame.size.height;
    self.bottomView.frame = CGRectMake(0, height, width, RefreshHeight);
    
    if ((currentPostion > (height - scrollFrameHeight)) && (height > scrollFrameHeight)){
        [self beginLoadMore];
    } else  if (! self.isWorking) {
        [self stopLoadMore];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [@"scrollView" isEqualToString:keyPath]) {
        if (! self.scrollView) {
            [self removeObserver:self forKeyPath:@"scrollView.contentOffset"];
            return;
        }
    }
    if (self.scrollView.dragging) {
        if (! self.isWorking) {
            if (self.scrollView.contentOffset.y >= 0) {
                if (self.canLoadMore)
                    [self addLoadMoreView];
            } else {
                if (self.canRefresh)
                    [self addRefreshView];
            }
        }
    } else {
        CGFloat currentPostion = self.scrollView.contentOffset.y;
        if (currentPostion > 0) return;
        if (fabs(currentPostion) > RefreshHeight) {
            [self beginRefresh];
        } else if (! self.isWorking) {
            [self stopRefresh];
        }
    }
}

- (void)beginRefresh {
    if (! self.canRefresh || self.isWorking) return;
    self.isWorking = YES;
    self.refreshType = RefreshTypeRefreshing;
//    [self.topActivity startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(RefreshHeight, 0, 0, 0);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(willPullDownToRefresh)]) {
            [self.delegate willPullDownToRefresh];
        }
        if (self.refresh) self.refresh ();
    }];
}

- (void)beginLoadMore {
    if (! self.canLoadMore || self.isWorking) return;
    self.isWorking = YES;
    self.refreshType = RefreshTypeLoading;
//    [self.bottomActivity startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, RefreshHeight, 0);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(willDragUpToLoadMore)]) {
            [self.delegate willDragUpToLoadMore];
        }
        if (self.loadMore) self.loadMore ();
    }];
}

- (void)stopRefresh {
    if (self.isWorking && self.refreshType == RefreshTypeRefreshing) {
        self.isWorking = NO;
        self.refreshType = RefreshTypeNone;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            [self.topActivity stopAnimating];
            [self.topView removeFromSuperview];
        }];
    }
}

- (void)stopLoadMore {
    if (self.isWorking && self.refreshType == RefreshTypeLoading) {
        self.isWorking = NO;
        self.refreshType = RefreshTypeNone;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            [self.bottomActivity stopAnimating];
            [self.bottomView removeFromSuperview];
        }];
    }
}

@end
