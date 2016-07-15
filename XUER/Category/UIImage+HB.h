//
//  UIImage+HB.h
//  maidoumi
//
//  Created by Chens on 14-8-4.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HB)
/**
 *  返回一张图片
 *
 *  @param name 图片名
 */
+ (instancetype)imageWithName:(NSString *)name;

/**
 *  返回一张能自由拉伸的图片
 *
 *  @param name 图片名
 */
+ (instancetype)resizableImage:(NSString *)name;

/**
 *  返回一张能自由拉伸的图片
 *
 *  @param name      图片名
 *  @param leftRatio 左边有多少比例不需要拉伸(0~1)
 *  @param topRatio  顶部有多少比例不需要拉伸(0~1)
 */
+ (instancetype)resizableImage:(NSString *)name leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio;

-(UIImage *)resizableImage;

@end
