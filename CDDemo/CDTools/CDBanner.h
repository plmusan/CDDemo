//
//  CDBanner.h
//  CDDemo
//
//  Created by x.wang on 15/4/28.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BannerDirection) {
    BannerDirectionTop,
    BannerDirectionBottom,
};
UIKIT_EXTERN NSString *BannerDirectionString(BannerDirection direction);

@interface CDBanner : NSObject

@property (nonatomic) CGFloat duration; // default is 2.0 second
@property (nonatomic) CGFloat bannerHeight; // default is 80.0 pt
@property (nonatomic, strong) UIColor *bannerBackgroung; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIColor *textColor; // default is [UIColor blackColor]
@property (nonatomic, strong) UIColor *borderColor; // default is nil. if nil, there is no border
@property (nonatomic) CGFloat borderWidth; // default is 1.0 pt

- (void)showBanner:(NSString *)msg inController:(UIViewController *)controller direction:(BannerDirection)direction;

@end
