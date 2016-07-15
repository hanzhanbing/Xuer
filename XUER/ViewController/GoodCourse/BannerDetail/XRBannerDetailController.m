//
//  XRBannerDetailController.m
//  XUER
//
//  Created by 韩占禀 on 15/10/3.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRBannerDetailController.h"
#import "TLShareView.h"

@interface XRBannerDetailController ()

@end

@implementation XRBannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_webView scalesPageToFit];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:_contentView animated:YES];
    
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    //字体颜色
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    //页面背景色
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#00FFFFFF'"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:_contentView animated:YES];
}

-(IBAction)goback:(id)sender
{
    [self pop];
}

-(IBAction)shareButtonClick:(id)sender
{
    TLShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"TLShareView" owner:nil options:nil] firstObject];
    [shareView showInView:_contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
