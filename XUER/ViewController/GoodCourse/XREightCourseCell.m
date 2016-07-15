//
//  XREightCourseCell.m
//  XUER
//
//  Created by lamco on 16/3/15.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "XREightCourseCell.h"
#import "XRCourseListController.h"
#import "XRLoginController.h"

@implementation XREightCourseCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray
{
    if (_dataSourceArray != dataSourceArray)
    {
        _dataSourceArray = dataSourceArray;
        for (int i = 0; i<self.dataSourceArray.count+1; i++) {
            UIView *view = (UIView *)[self viewWithTag:100+i];
            UIImageView *imgView = (UIImageView *)[self viewWithTag:200+i];
            UILabel *label = (UILabel *)[self viewWithTag:300+i];
            if (i == self.dataSourceArray.count) { //更多
                imgView.image = [UIImage imageNamed:@"gengduo"];
                label.text = @"更多";
            } else {
                XRTypeInfo *typeInfo = self.dataSourceArray[i];
                [imgView sd_setImageWithURL:[NSURL URLWithString:typeInfo.img]];
                label.text = typeInfo.name;
            }
//            view.alpha = 0.01;
//            [UIView animateWithDuration:1 animations:^{
//                view.alpha = 1.0;
//            }];
        }
    }
}

//设置tabbar切换动画
-(void)tabbarAnimation{
    /*!
     typedef enum : NSUInteger {
     Fade = 1,                   //淡入淡出
     Push,                       //推挤
     Reveal,                     //揭开
     MoveIn,                     //覆盖
     Cube,                       //立方体
     SuckEffect,                 //吮吸
     OglFlip,                    //翻转
     RippleEffect,               //波纹
     PageCurl,                   //翻页
     PageUnCurl,                 //反翻页
     CameraIrisHollowOpen,       //开镜头
     CameraIrisHollowClose,      //关镜头
     CurlDown,                   //下翻页
     CurlUp,                     //上翻页
     FlipFromLeft,               //左翻转
     FlipFromRight,              //右翻转
     
     } AnimationType;
     */
    AppDelegate *sap = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *bb =(UITabBarController *)sap.window.rootViewController;
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setType:@"cube"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[bb.view layer]addAnimation:animation forKey:@"switchView"];
}

- (IBAction)jumpCourseList:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 107) {
        [self tabbarAnimation];
        //跳转到全部课程
        self.superVC.tabBarController.selectedIndex = 1;
    } else {
        XRTypeInfo *typeInfo = self.dataSourceArray[btn.tag-100];
        XRCourseListController *courseListC = [[XRCourseListController alloc] init];
        courseListC.hidesBottomBarWhenPushed = YES;
        courseListC.typeInfo = typeInfo;
        [self.superVC.navigationController pushViewController:courseListC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
    }
}

@end
