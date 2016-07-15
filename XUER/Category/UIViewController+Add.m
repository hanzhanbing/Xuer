//
//  UIViewController+Add.m
//  XUER
//
//  Created by 韩占禀 on 15/8/24.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "UIViewController+Add.h"

#define kCustomViewTag 1111

@implementation UIViewController (Add)

-(void)addCustomNavagationBarWithTitle:(NSString *)title isNeedBackButton:(BOOL)isNeedBackButon
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:customView];
    customView.tag = kCustomViewTag;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 44)];
    titleLabel.centerX = customView.width/2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = title;
    [customView addSubview:titleLabel];
    customView.backgroundColor = RGBCOLOR(65, 158, 150);
    
    if (isNeedBackButon)
    {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
        [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [customView addSubview:backButton];
    }
}

-(UIView *)getCustomView
{
    return [self.view viewWithTag:kCustomViewTag];
}

-(void)pop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popToRoot:(BOOL)animated
{
    for (int i = 1; i < self.navigationController.viewControllers.count; i++)
    {
        UIViewController *vc = self.navigationController.viewControllers[i];
        [[NSNotificationCenter defaultCenter] removeObserver:vc];
    }
    [self.navigationController popToRootViewControllerAnimated:animated];
}

-(void)popToController:(UIViewController *)controller
{
    for (int i = (int)self.navigationController.viewControllers.count-1; i >= 0; i--)
    {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isEqual:controller])
        {
            break;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:vc];
    }
    [self.navigationController popToViewController:controller animated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
