//
//  CDToast.h
//  CDDemo
//
//  Created by x.wang on 15/4/28.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat DefaultToastTime;
/*
 * Toast() and Toast_f() can easy to show `Toast' message, they both use [CDToast showMessage:after:] method.
 * Toast() use the `DefaultTime', Toast_f() use a custom time which is never less than 1.0 second.
 *
 *  There is a `message queue' handler all message, when first did disappear, the second message show.
 */
UIKIT_EXTERN void Toast(NSString *msg);
UIKIT_EXTERN void Toast_f(NSString *msg, CGFloat time);

@interface CDToastConfigure : NSObject

@property (nonatomic) UIColor *backgroundColor; // default is [UIColor blackColor]
@property (nonatomic) UIColor *textColor; // default is [UIColor whiteColor]
@property (nonatomic) UIFont *font; // default is [UIFont systemFontOfSize:17.0];
@property (nonatomic) CGFloat cornerRadius; // default is 0.0

+ (CDToastConfigure *)defaultToastConfigure;

@end

@interface CDToast : NSObject

+ (instancetype)shareInstance;

- (void)setToastConfigure:(CDToastConfigure *)conf;
- (void)showMessage:(NSString *)msg after:(CGFloat)time;

@end


