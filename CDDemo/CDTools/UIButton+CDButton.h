//
//  UIButton+CDButton.h
//  CDDemo
//
//  Created by x.wang on 15/7/3.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CDButton)

@property (nonatomic, readonly) BOOL isLoading;

- (void)startLoadingAnimating;
- (void)stopLoadingAnimating;

@end
