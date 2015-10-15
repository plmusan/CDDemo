//
//  CDSegmented.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDSegmented.h"

@interface  CDSegmented ()

@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray *enables;
@property (nonatomic) NSUInteger selectedButtonIndex;

@end

@implementation CDSegmented


- (instancetype)initWithButtonTitles:(NSArray *)titles viewSize:(CGSize)size; {
    self = [super init];
    [self instanceButtonWithTitles:titles];
    [self configViewWithButtonsAndSize:size];
    return self;
}

- (void)instanceButtonWithTitles:(NSArray *)titles{
    self.buttons = [NSMutableArray array];
    self.enables = [NSMutableArray array];
    for (NSString *title in titles) {
        UIButton *button = [self buttonWithTitle:title];
        [self.buttons addObject:button];
        [self.enables addObject:[NSNumber numberWithBool:YES]];
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title; {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    return button;
}

- (UIButton *)buttonWithImage:(UIImage *)image; {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

- (void)configViewWithButtonsAndSize:(CGSize)size; {
    self.frame = CGRectMake(0, 0, size.width, size.height);
    [self configViewWithButtons];
}

- (NSUInteger)buttonsCount {
    return self.buttons.count;
}

- (void)configViewWithButtons;{
    for (UIButton *button in self.buttons) button.selected = NO;
    if (self.buttonsCount > 0)
        ((UIButton *)[self.buttons objectAtIndex:self.selectedButtonIndex]).selected = YES;
    [self drowViewWithButtons];
}

- (void)drowViewWithButtons; {
    for (UIView *view in [self subviews]) [view removeFromSuperview];
    for (UIButton *button in self.buttons)
        [self addButton:button toView:self index:[self.buttons indexOfObject:button]];
    [self addBackgroundView];
    [self layoutIfNeeded];
}

- (void)addBackgroundView; {
    UIView *backView = [[UIView alloc] init];
    [self insertSubview:backView atIndex:0];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(backView);
    NSString *horizontal = @"H:|-0-[backView]-0-|";
    NSString *vertical = @"V:|-0-[backView]-0-|";
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:horizontal
                                                            options:0
                                                            metrics:nil
                                                              views:dict1];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vertical
                                                            options:0
                                                            metrics:nil
                                                              views:dict1];
    NSMutableArray *consArray = [NSMutableArray array];
    [consArray addObjectsFromArray:arr1];
    [consArray addObjectsFromArray:arr2];
    [self addConstraints:consArray];
    backView.layer.borderColor = self.borderColor ? self.borderColor.CGColor : [UIColor whiteColor].CGColor;
    backView.layer.borderWidth = 1;
    if (self.buttons.count == 0) backView.backgroundColor = [UIColor clearColor];
    else backView.backgroundColor = self.borderColor ? self.borderColor : [UIColor whiteColor];
}

- (void)addButton:(UIButton *)button toView:(UIView*)view index:(NSUInteger)index; {
    [view addSubview:button];
    button.clipsToBounds = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonTuochDown:) forControlEvents:UIControlEventTouchDown];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(button);
    CGFloat btnWidth = (self.frame.size.width - 1) / self.buttons.count - 1;
    btnWidth = btnWidth < 0 ? 0 : btnWidth;
    NSString *topAndBottom  =@"V:|-1-[button]-1-|";
    NSString *left = [NSString stringWithFormat:@"H:|-%f-[button]",(1 + (btnWidth + 1) * index)];
    NSString *width = [NSString stringWithFormat:@"H:[button(%f)]",  btnWidth];
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:topAndBottom
                                                            options:0
                                                            metrics:nil
                                                              views:dict1];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:left
                                                            options:0
                                                            metrics:nil
                                                              views:dict1];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:width
                                                            options:0
                                                            metrics:nil
                                                              views:dict1];
    NSMutableArray *consArray = [NSMutableArray array];
    [consArray addObjectsFromArray:arr1];
    [consArray addObjectsFromArray:arr2];
    [consArray addObjectsFromArray:arr3];
    [self addConstraints:consArray];
}

- (void)selectedButtonAtIndex:(NSUInteger)index; {
    [self ifButtonsNil];
    if (index < self.buttons.count) {
        NSNumber *number = [self.enables objectAtIndex:index];
        if (number.boolValue) {
            ((UIButton *)[self.buttons objectAtIndex:self.selectedButtonIndex]).selected = NO;
            self.selectedButtonIndex = index;
            ((UIButton *)[self.buttons objectAtIndex:self.selectedButtonIndex]).selected = YES;
            if ([self.delegate respondsToSelector:@selector(segmentedControl:didSelectedAtIndex:)])
                [self.delegate segmentedControl:self didSelectedAtIndex:index];
        }
    }
}

- (void)buttonTuochDown:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(segmentedControl:shouldSelectedAtIndex:)]) {
        BOOL btnCanSelected = [self.delegate segmentedControl:self shouldSelectedAtIndex:index];
        [self.enables replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:btnCanSelected]];
    }
}

- (void)buttonDidSelected:(id)sender {
    [self selectedButtonAtIndex:[self.buttons indexOfObject:sender]];
}

- (void)insertButton:(UIButton *)button atIndex:(NSUInteger)index {
    [self ifButtonsNil];
    if (index > self.buttons.count) index = self.buttons.count;
    if (index <= self.selectedButtonIndex && self.buttons.count != 0) self.selectedButtonIndex ++;
    [self.buttons insertObject:button atIndex:index];
    [self.enables insertObject:[NSNumber numberWithBool:YES] atIndex:index];
    [self configViewWithButtons];
}

- (void)insertButtonWithTitle:(NSString *)title atIndex:(NSUInteger)index; {
    UIButton *button = [self buttonWithTitle:title];
    [self insertButton:button atIndex:index];
}

- (void)insertButtonWithImage:(UIImage *)image atIndex:(NSUInteger)index; {
    UIButton *button = [self buttonWithImage:image];
    [self insertButton:button atIndex:index];
}

- (void)removeButtonAtIndex:(NSUInteger)index; {
    [self ifButtonsNil];
    if (index < self.buttons.count) {
        if (index <= self.selectedButtonIndex && self.selectedButtonIndex != 0) self.selectedButtonIndex --;
        [self.buttons removeObjectAtIndex:index];
        [self.enables removeObjectAtIndex:index];
        if (self.buttons.count == 0) [self drowViewWithButtons];
        else [self configViewWithButtons];
    }
}

- (void)removeAllButtons; {
    [self ifButtonsNil];
    [self.buttons removeAllObjects];
    [self.enables removeAllObjects];
    self.selectedButtonIndex = 0;
    [self drowViewWithButtons];
}

- (void)setEnabled:(BOOL)enabled atIndex:(NSUInteger)index; {
    [self ifButtonsNil];
    if (index < self.enables.count)
        [self.enables replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:enabled]];
}

- (BOOL)isEnabledAtIndex:(NSUInteger)index; {
    BOOL enable = NO;
    [self ifButtonsNil];
    if (index < self.enables.count)
        enable = ((NSNumber *)[self.enables objectAtIndex:index]).boolValue;
    return enable;
}

- (void)setImage:(UIImage *)image atIndex:(NSUInteger)index forState:(UIControlState)state; {
    [self ifButtonsNil];
    if (index < self.buttons.count)
        [(UIButton *)[self.buttons objectAtIndex:index] setBackgroundImage:image forState:state];
}

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index forState:(UIControlState)state; {
    [self ifButtonsNil];
    if (index < self.buttons.count)
        [(UIButton *)[self.buttons objectAtIndex:index] setTitle:title forState:state];
}

- (NSString *)titleAtIndex:(NSUInteger)index forState:(UIControlState)state; {
    NSString *title = nil;
    [self ifButtonsNil];
    if (index < self.buttons.count)
        title = [((UIButton *)[self.buttons objectAtIndex:index]) titleForState:state];
    return title;
}

- (void)setTitleColor:(UIColor *)color atIndex:(NSUInteger)index forState:(UIControlState)state; {
    [self ifButtonsNil];
    if (index < self.buttons.count)
        [(UIButton *)[self.buttons objectAtIndex:index] setTitleColor:color forState:state];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self ifButtonsNil];
    [self configViewWithButtons];
}

- (void)ifButtonsNil; {
    if ( ! self.buttons) [self instanceButtonWithTitles:@[@"First", @"Second"]];
}

@end


@implementation CDSegmented (Tools)

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
