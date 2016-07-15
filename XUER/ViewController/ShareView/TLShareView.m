//
//  TLShareView.m
//  ThirdLogin
//
//  Created by 韩占禀 on 15/8/20.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "TLShareView.h"
#import "XRShareCenter.h"
#import "UIView+Frame.h"
#import "UIView+HB.h"
#import "MBProgressHUD.h"

#define kShareItemBaseTag 100

@implementation TLShareView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_weiboView addGestureRecognizer:tap];
    _weiboView.tag = kShareItemBaseTag+ShareTypeSinaWeibo;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_wechatView addGestureRecognizer:tap];
    _wechatView.tag = kShareItemBaseTag+ShareTypeWeixiSession;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_timelineView addGestureRecognizer:tap];
    _timelineView.tag = kShareItemBaseTag+ShareTypeWeixiTimeline;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_qqView addGestureRecognizer:tap];
    _qqView.tag = kShareItemBaseTag+ShareTypeQQ;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_qqZoneView addGestureRecognizer:tap];
    _qqZoneView.tag = kShareItemBaseTag+ShareTypeQQSpace;//设置tag值加上一个基数
    
    //点击背景隐藏shareView
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [_bgView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:kShareFinishedNotification object:nil];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    
    //点击之后减去基数得到实际ShareType
    ShareType type = (int)(view.tag - kShareItemBaseTag);
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [XRShareCenter shareToSocialPlatformWithType:type];
}

-(void)showInView:(UIView *)view
{
    //如果分享view的父视图不为空，将它从父视图移除
    if (self.superview != nil)
    {
        [self removeFromSuperview];
    }
    //设置self的frame跟我要在上边展示的view的一样大
    self.frame = view.bounds;
    //将self加载到view上
    [view addSubview:self];
    
    _contentView.y = view.height;
    _bgView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.33333;
        _contentView.y = view.height - _contentView.height;
    }];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _bgView.frame = self.bounds;
    _contentView.width = self.width;
    [self refreshShareView];
}

-(void)refreshShareView
{
    _wechatView.centerX = self.centerX;
    
    _weiboView.centerX = _wechatView.x/2;
    _timelineView.centerX = [_wechatView getFrame_right]+_weiboView.centerX;
    _qqView.centerX = _weiboView.centerX;
}

-(void)hideView
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    _bgView.alpha = 0.33333;
    UIView *view = self.superview;
    _contentView.y = view.height - _contentView.height;
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.y = view.height;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
