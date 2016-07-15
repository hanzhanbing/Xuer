//
//  XRVerifyCodeController.h
//  XUER
//
//  Created by 韩占禀 on 15/8/25.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRVerifyCodeController : UIViewController
{
    IBOutlet UIView         *_contentView;
    IBOutlet UILabel        *_phoneHintLabel;
    
    IBOutlet UITextField    *_verifyCodeTextField;
    IBOutlet UIImageView    *_heightLineImageView;
    IBOutlet UIButton       *_resendButton;
    IBOutlet UILabel        *_timeLabel;
    
    IBOutlet UIButton       *_nextButton;
    
    NSUInteger              _countDownTime;
    NSTimer                 *_timer;
}

@property (nonatomic,strong) NSString *phoneNum;

@end
