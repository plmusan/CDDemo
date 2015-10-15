//
//  CDAlert.h
//  CDDemo
//
//  Created by x.wang on 15/4/29.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ClickButtonIndex) {
    ClickButtonIndexCancel,
    ClickButtonIndexOK,
};

typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeNon = 0,
    AlertTypeAlertView,
    AlertTypeAlertController,
};

typedef void (^AlertHandler)(ClickButtonIndex index);

UIKIT_EXTERN NSString *ClickButtonIndexString(ClickButtonIndex index);
UIKIT_EXTERN NSString *AlertTypeString(AlertType type);

@interface CDAlert : NSObject

@property (nonatomic, strong, readonly) id showingAlert;
@property (nonatomic, readonly) AlertType showingAlertType;

+ (instancetype)shareInstance;

- (void)showAlertWithMsg:(NSString *)msg handler:(AlertHandler)handler; // only `OK' button
- (void)showAlertWithMsg:(NSString *)msg cancelButton:(NSString *)cancelButton OKButton:(NSString *)OKButton handler:(AlertHandler)handler __attribute((nonnull(2,3)));
- (void)showAlert:(id)alert handler:(AlertHandler)handler __attribute((nonnull(1)));

- (void)dismissShowingAlertAndStop;
- (void)dismissShowingAlertAndShowNext;

- (void)start;
- (void)stop;
- (void)clearn;

@end
