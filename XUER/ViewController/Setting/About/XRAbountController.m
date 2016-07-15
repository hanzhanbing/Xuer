//
//  XRAbountController.m
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRAbountController.h"
#import "TLShareView.h"

@interface XRAbountController ()

@end

@implementation XRAbountController

-(void)viewLayout
{
    [_contentView setWidthToAutoresizeScreenWidth];
    [_contentView setHeightToAutoresizeScreenHeight];
    
    [_scrollView setWidthToAutoresizeScreenWidth];
    [_scrollView setHeightToAutoresizeScreenHeight];
    
    _xuerLogoImageView.centerX = kScreenWidth/2;
    _circleArcImageView.centerX = kScreenWidth/2;
    _versionLabel.centerX = kScreenWidth/2;
    [_introduceLabel setWidthToAutoresizeScreenWidth];
    _qrCodeImageView.centerX = kScreenWidth/2;
    _checkUpdateButton.centerX = kScreenWidth/2;
    _copyrightLabel.centerX = kScreenWidth/2;
    [_copyrightLabel setYToAutoresizeScreenHeight];
    _copyrightLabel.y -= 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any add
    [self viewLayout];
    [self addCustomNavagationBarWithTitle:@"关于我们" isNeedBackButton:YES];
    
    [_versionLabel setText:[NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]]; //app版本
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 20, 60, 44)];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [[self getCustomView] addSubview:shareButton];
    
    _scrollView.contentSize = CGSizeMake(0, _scrollView.height+10);
}

-(void)shareButtonClick:(UIButton *)button
{
    TLShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"TLShareView" owner:nil options:nil] firstObject];
    [shareView showInView:_contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
