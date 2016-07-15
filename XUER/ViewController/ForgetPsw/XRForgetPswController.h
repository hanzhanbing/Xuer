//
//  XRForgetPswController.h
//  XUER
//
//  Created by lamco on 16/3/4.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRForgetPswController : UIViewController
{
    IBOutlet UITextField *_inputPhoneNumber;
    IBOutlet UITextField *_inputNewPsw;
    
    IBOutlet UITextField *_verifyCodeTextField;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UIButton *_resendButton;
    
    IBOutlet UIButton *_doneButton;
    
    NSUInteger              _countDownTime;
    NSTimer                 *_timer;
}

@property (nonatomic,strong) NSString *phoneNum;

@end
