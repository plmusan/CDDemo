//
//  CDFunction.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

///To obtain a random integer, in the range [from, to)
UIKIT_EXTERN NSInteger cd_random(NSInteger from, NSInteger to);
/// create and return a pixel UIImage object with UICloor
UIKIT_EXTERN UIImage *cd_create_image(UIColor *color);
/// create and return a specified size UIImage object with an image and scale size
UIKIT_EXTERN UIImage *cd_scale_size(UIImage *image, CGSize size);
/// return a integer value with string like "FFFFFF"
UIKIT_EXTERN NSInteger cd_integer_value(NSString *string);

