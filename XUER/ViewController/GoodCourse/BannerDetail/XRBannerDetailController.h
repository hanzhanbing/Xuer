//
//  XRBannerDetailController.h
//  XUER
//
//  Created by 韩占禀 on 15/10/3.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRBannerDetailController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UILabel    *_titleLabel;
    IBOutlet UIView     *_contentView;
    IBOutlet UIWebView  *_webView;
}

@property (nonatomic,strong) NSString   *url;

@end
