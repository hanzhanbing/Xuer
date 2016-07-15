//
//  XRLoginController.h
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRLoginController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView    *_bgImageView;
    IBOutlet UIView         *_contentView;
    
    IBOutlet UIImageView    *_welcomeImageView;
    
    IBOutlet UIView         *_phoneView;
    IBOutlet UITextField    *_phoneTextField;
    
    IBOutlet UIView         *_passwordView;
    IBOutlet UITextField    *_passwordTextField;
    
    IBOutlet UIButton       *_loginButton;
    IBOutlet UIButton       *_registerButton;
    IBOutlet UIButton       *_forgetPswButton;
    
    IBOutlet UIView         *_thirdLoginView;
    IBOutlet UIButton       *_weiboButton;
    IBOutlet UIButton       *_wechatButton;
    IBOutlet UIButton       *_qqButton;
}

@end
