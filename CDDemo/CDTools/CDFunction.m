//
//  CDFunction.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDFunction.h"

NSInteger cd_random(NSInteger from, NSInteger to){
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

UIImage *cd_create_image(UIColor *color){
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage *cd_scale_size(UIImage *image, CGSize size){
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

NSInteger cd_integer_value(NSString *string){
    NSInteger result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanInteger:&result];
    return result;
}
