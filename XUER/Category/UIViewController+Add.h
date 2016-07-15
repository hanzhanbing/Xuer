//
//  UIViewController+Add.h
//  XUER
//
//  Created by 韩占禀 on 15/8/24.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Add)

-(void)addCustomNavagationBarWithTitle:(NSString *)title isNeedBackButton:(BOOL)isNeedBackButon;

-(UIView *)getCustomView;

-(void)pop;

-(void)popToRoot:(BOOL)animated;

-(void)popToController:(UIViewController *)controller;

-(void)viewLayout;

@end
