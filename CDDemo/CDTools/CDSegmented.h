//
//  CDSegmented.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDSegmentedDelegate;

@interface CDSegmented : UIView

@property (nonatomic, weak) id<CDSegmentedDelegate> delegate;
@property (nonatomic) UIColor *borderColor; // default is white
@property (nonatomic, readonly) NSUInteger selectedButtonIndex; // default is 0
- (void)selectedButtonAtIndex:(NSUInteger)index; // change selectedButton with index
@property (nonatomic, readonly) NSUInteger buttonsCount;

/// use this method without draw view on xib or storyboard
- (instancetype)initWithButtonTitles:(NSArray *)titles viewSize:(CGSize)size;

- (void)insertButtonWithTitle:(NSString *)title atIndex:(NSUInteger)index;
- (void)insertButtonWithImage:(UIImage *)image atIndex:(NSUInteger)index;
- (void)removeButtonAtIndex:(NSUInteger)index;
- (void)removeAllButtons;

- (void)setEnabled:(BOOL)enabled atIndex:(NSUInteger)index; // default is YES
- (BOOL)isEnabledAtIndex:(NSUInteger)index;

/// default is blackColor with normal state and grayColor with selected state
- (void)setImage:(UIImage *)image atIndex:(NSUInteger)index forState:(UIControlState)state;
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index forState:(UIControlState)state; // default is `First` and `Second`
- (NSString *)titleAtIndex:(NSUInteger)index forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color atIndex:(NSUInteger)index forState:(UIControlState)state; // default is white


@end

@protocol CDSegmentedDelegate <NSObject>
@optional
/// callback when button touch down, return YES if it can selected, has a hight priority
- (BOOL)segmentedControl:(CDSegmented *)segmented shouldSelectedAtIndex:(NSUInteger)index;
/// callback when button selected
- (void)segmentedControl:(CDSegmented *)segmented didSelectedAtIndex:(NSUInteger)index;

@end


@interface CDSegmented (Tools)
- (UIImage *)imageWithColor:(UIColor *)color;
@end


