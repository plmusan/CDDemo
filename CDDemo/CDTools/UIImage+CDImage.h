//
//  UIImage+CDImage.h
//  CDDemo
//
//  Created by x.wang on 15/8/26.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, UIImageRoundedCorner) {
    UIImageRoundedCornerTopLeft = 1, // 左上角有圆角
    UIImageRoundedCornerTopRight = 1 << 1, // 右上角有圆角
    UIImageRoundedCornerBottomRight = 1 << 2, // 右下角有圆角
    UIImageRoundedCornerBottomLeft = 1 << 3, // 左下角有圆角
    
    UIImageRoundedCornerAll = 0xF, // 四个角都有圆角
};

/*!
 *  @author x.wang, 08-27
 *
 *  以下方法均是使用Bitmap重新绘制图片，因而比较耗时
 *  粗略估计处理一张1920×1200的图片需要100~200毫秒
 */
@interface UIImage (CDImage)

/*!
 *  @author x.wang, 08-26
 *
 *  保持图片大小、比例不变，根据给定的参数添加圆角
 *
 *  @param radius     圆角半径，单位为像素
 *  @param cornerMask 标记哪些角需要圆角
 *
 *  @return 一个新的UIImage对象，按传入的参数切割
 */
- (UIImage *)roundedRectWithRadius:(CGFloat)radius cornerMask:(UIImageRoundedCorner)cornerMask;
/*!
 *  @author x.wang, 08-26
 *
 *  按传入的参数生成圆角，传入的size和image的size比例不同时图片会被拉伸而失真
 *
 *  @param radius     圆角半径，单位为像素
 *  @param size       新图片的大小，单位为像素
 *  @param cornerMask 标记哪些角需要圆角
 *
 *  @return 一个新的UIImage对象，按传入的参数切割
 */
- (UIImage *)roundedRectWithRadius:(CGFloat)radius size:(CGSize)size cornerMask:(UIImageRoundedCorner)cornerMask;

/*!
 *  @author x.wang, 08-26
 *
 *  按传入的参数截取一部分Image图像并返回
 *
 *  @param rect 由截取图片的原点和大小构成，单位为像素
 *
 *  @return 一个新的UIImage对象，按传入的参数切割
 */
- (UIImage *)clipImageWithRect:(CGRect)rect;
/*!
 *  @author x.wang, 08-26
 *
 *  首先图片会按比例拉伸到窄变宽为2倍radius大小，然后以图片中心为圆心
 *  radius参数为半径生成一个圆形的图片并返回
 *
 *  @param radius 生成图片的半径，单位为像素
 *
 *  @return 一个新的UIImage对象，按传入的参数切割
 */
- (UIImage *)clipCircleImageWithRadius:(CGFloat)radius;

@end
