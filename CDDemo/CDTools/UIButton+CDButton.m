//
//  UIButton+CDButton.m
//  CDDemo
//
//  Created by x.wang on 15/7/3.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import "UIButton+CDButton.h"
#import <objc/runtime.h>

static void *const kIndicatorView = "CDButton.IndicatorView";

@implementation UIButton (CDButton)

- (void)setIndicatorView:(UIActivityIndicatorView *)indicatorView {
    objc_setAssociatedObject(self, kIndicatorView, indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicatorView {
    id result = objc_getAssociatedObject(self, kIndicatorView);
    if ([result isKindOfClass:[UIActivityIndicatorView class]]) {
        return result;
    }
    return nil;
}

- (BOOL)isLoading {
    return (self.indicatorView && [self.subviews containsObject:self.indicatorView]);
}

- (void)startLoadingAnimating; {
    if (! self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    [self addSubview:self.indicatorView];
    CGSize size = self.frame.size;
    self.indicatorView.center = CGPointMake(size.width / 2, size.height / 2);
    [self.indicatorView startAnimating];
}

- (void)stopLoadingAnimating; {
    [self.indicatorView removeFromSuperview];
    [self.indicatorView stopAnimating];
    self.indicatorView = nil;
}

@end
