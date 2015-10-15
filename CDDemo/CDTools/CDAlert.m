//
//  CDAlert.m
//  CDDemo
//
//  Created by x.wang on 15/4/29.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDAlert.h"

#define ALERT_DISMISS_DELAY 0.5

static const NSString *const ALERT = @"alert";
static const NSString *const HANDLER = @"handler";

NSString *AlertTypeString(AlertType type) {
    switch (type) {
        case AlertTypeAlertController:
            return @"AlertTypeAlertController";
        case AlertTypeAlertView:
            return @"AlertTypeAlertView";
        default:
            return @"AlertTypeNon";
    }
}

NSString *ClickButtonIndexString(ClickButtonIndex index) {
    if (index == ClickButtonIndexCancel) {
        return @"ClickButtonIndexCancel";
    } else {
        return @"ClickButtonIndexOK";
    }
}

@interface CDAlert () <UIAlertViewDelegate>

@property (nonatomic, strong) id showingAlert;
@property (nonatomic) AlertType showingAlertType;
@property (nonatomic) BOOL canShowNext;
@property (nonatomic, strong) AlertHandler handler;
@property (nonatomic, strong) UIViewController *rootController;
@property (nonatomic, strong) NSMutableArray *alertQueue;

@end

@implementation CDAlert

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
        self.rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
        self.alertQueue = [NSMutableArray array];
        self.canShowNext = YES;
    }
    return self;
}

- (void)showAlertWithMsg:(NSString *)msg handler:(AlertHandler)handler; {
    id alert = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (handler) handler (ClickButtonIndexOK);
            [self performSelector:@selector(showNext) withObject:nil afterDelay:ALERT_DISMISS_DELAY];
        }];
        [alert addAction:action];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [self showAlert:alert handler:handler];
}

- (void)showAlertWithMsg:(NSString *)msg cancelButton:(NSString *)cancelButton OKButton:(NSString *)OKButton handler:(AlertHandler)handler; {
    id alert = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:OKButton style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (handler) handler (ClickButtonIndexOK);
            [self performSelector:@selector(showNext) withObject:nil afterDelay:ALERT_DISMISS_DELAY];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (handler) handler (ClickButtonIndexCancel);
            [self performSelector:@selector(showNext) withObject:nil afterDelay:ALERT_DISMISS_DELAY];
        }];
        [alert addAction:action];
        [alert addAction:cancel];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,nil];
    }
    [self showAlert:alert handler:handler];
}

- (void)showAlert:(id)alert handler:(AlertHandler)handler; {
    if (self.showingAlert) {
        NSDictionary *dic;
        if (self.handler)
            dic = @{ALERT:alert, HANDLER:handler};
        else
            dic = @{ALERT:alert};
        [self.alertQueue addObject:dic];
        return;
    }
    self.handler = handler;
    self.showingAlert = alert;
    if ([alert isKindOfClass:[UIAlertView class]]) {
        self.showingAlertType = AlertTypeAlertView;
        UIAlertView *alertView = alert;
        alertView.delegate = self;
        [alertView show];
    } else if ([alert isKindOfClass:[UIAlertController class]]) {
        self.showingAlertType = AlertTypeAlertController;
        [self.rootController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showNext; {
    [self changeShowingNon];
    if (self.alertQueue.count > 0 && self.canShowNext) {
        NSDictionary *dic = self.alertQueue.firstObject;
        id alert = [dic objectForKey:ALERT];
        AlertHandler handler = [dic objectForKey:HANDLER];
        [self.alertQueue removeObjectAtIndex:0];
        [self showAlert:alert handler:handler];
    }
}

- (void)dismissShowingAlert; {
    if (self.showingAlert) {
        switch (self.showingAlertType) {
            case AlertTypeAlertView:
            {
                UIAlertView *alertView = self.showingAlert;
                [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
            }
                break;
            case AlertTypeAlertController:
            {
                UIAlertController *alertController = self.showingAlert;
                [alertController dismissViewControllerAnimated:NO completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)changeShowingNon {
    self.showingAlert = nil;
    self.handler = nil;
    self.showingAlertType = AlertTypeNon;
}

- (void)dismissShowingAlertAndStop; {
    [self dismissShowingAlert];
    [self stop];
}

- (void)dismissShowingAlertAndShowNext; {
    [self dismissShowingAlert];
    [self performSelector:@selector(showNext) withObject:nil afterDelay:ALERT_DISMISS_DELAY];
}

- (void)start; {
    self.canShowNext = YES;
    if (self.showingAlert) return;
    [self showNext];
}

- (void)stop; {
    self.canShowNext = NO;
}

- (void)clearn; {
    [self dismissShowingAlertAndStop];
    [self.alertQueue removeAllObjects];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (self.handler) self.handler(ClickButtonIndexCancel);
    } else {
        if (self.handler) self.handler(ClickButtonIndexOK);
    }
    [self performSelector:@selector(showNext) withObject:nil afterDelay:ALERT_DISMISS_DELAY];
}

@end



