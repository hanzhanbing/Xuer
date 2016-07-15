//
//  UIImage+HB.m
//  maidoumi
//
//  Created by Chens on 14-8-4.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import "UIImage+HB.h"

@implementation UIImage (HB)
+ (UIImage *)imageWithName:(NSString *)name
{
    // 0.需要返回的图片
    UIImage *image = nil;
    
    image = [UIImage imageNamed:name];

//    // 1.判断系统版本
//    if (iOS7) {
//        NSString *ios7Name = [name stringByAppendingString:@"_os7"];
//        // 加载iOS7的图片
//        image = [self imageNamed:ios7Name];
//    }
//    
//    // 2.图片不存在
//    if (image == nil) {
//        image = [self imageNamed:name];
//    }
    
    return image;
}

+ (UIImage *)resizableImage:(NSString *)name
{
    return [self resizableImage:name leftRatio:0.5 topRatio:0.5];
}

+ (UIImage *)resizableImage:(NSString *)name leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio
{
    UIImage *image = [self imageWithName:name];
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

-(UIImage *)resizableImage
{
    CGFloat left = self.size.width * 0.5;
    CGFloat top = self.size.height * 0.5;
    return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

@end
