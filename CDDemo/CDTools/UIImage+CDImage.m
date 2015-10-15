//
//  UIImage+CDImage.m
//  CDDemo
//
//  Created by x.wang on 15/8/26.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import "UIImage+CDImage.h"

@implementation UIImage (CDImage)

-(void)addRoundedRectToPath:(CGContextRef)context withrect:(CGRect)rect radius:(CGFloat)radius mask:(UIImageRoundedCorner)cornerMask {
    
    CGContextBeginPath(context);

    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);

    if (cornerMask & UIImageRoundedCornerTopLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    if (cornerMask & UIImageRoundedCornerTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    if (cornerMask & UIImageRoundedCornerBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        radius, 0.0f, -M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    if (cornerMask & UIImageRoundedCornerBottomLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        -M_PI / 2, M_PI, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
    CGContextClip(context);
}

- (UIImage *)roundedRectWithRadius:(CGFloat)radius cornerMask:(UIImageRoundedCorner)cornerMask {
    return [self roundedRectWithRadius:radius size:self.size cornerMask:cornerMask];
}

- (UIImage *)roundedRectWithRadius:(CGFloat)radius size:(CGSize)size cornerMask:(UIImageRoundedCorner)cornerMask {

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    CGContextRef context = CGBitmapContextCreateWithRect(rect);

    [self addRoundedRectToPath:context withrect:rect radius:radius mask:cornerMask];
    
    UIImage *newImage = [self drawImageInContext:context withRect:rect];
    
    CGContextRelease(context);
    
    return newImage;
}

- (UIImage *)clipImageWithRect:(CGRect)rect {
    
    CGContextRef context = CGBitmapContextCreateWithRect(CGRectMake(0, 0, rect.size.width, rect.size.height));
    UIImage *newImage = [self drawImageInContext:context withRect:CGRectMake(-1 * rect.origin.x, -1 * rect.origin.y, self.size.width, self.size.height)];
    CGContextRelease(context);
    
    return newImage;
}

- (UIImage *)clipCircleImageWithRadius:(CGFloat)radius {
    CGFloat x = 0, y = 0;
    CGFloat width = 0, height = 0;
    if (self.size.width < self.size.height) {
        width = radius * 2;
        height = (self.size.height / self.size.width) * width;
        y = (height - width) / 2;
    } else {
        height = radius * 2;
        width = (self.size.width / self.size.height) * height;
        x = (width - height) / 2;
    }
    
    CGRect contextRect = CGRectMake(-1 * x, -1 * y, width, height);
    CGRect clipRect = CGRectMake(0, 0, 2 * radius, 2 * radius);
    
    CGContextRef context = CGBitmapContextCreateWithRect(clipRect);

    [self addRoundedRectToPath:context withrect:clipRect radius:radius mask:UIImageRoundedCornerAll];
    
    UIImage *newImage = [self drawImageInContext:context withRect:contextRect];
    
    CFRelease(context);
    
    return newImage;
}

static CGContextRef CGBitmapContextCreateWithRect(CGRect rect) {
    NSInteger w = rect.size.width;
    NSInteger h = rect.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, 1);
    CGColorSpaceRelease(colorSpace);
    
    // 翻转context的坐标系，使其和UIKit框架一致
    CGContextTranslateCTM(context, 0, h);
    CGContextScaleCTM(context, 1.0, -1.0);
    return context;
}

- (UIImage *)drawImageInContext:(CGContextRef)context withRect:(CGRect)rect {
    //    CGContextDrawImage(context, rect, self.CGImage); // 使用此函数会自动拉伸图片
    UIGraphicsPushContext(context);
    [self drawInRect:rect];
    UIGraphicsPopContext();
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);

    return newImage;
}

@end
