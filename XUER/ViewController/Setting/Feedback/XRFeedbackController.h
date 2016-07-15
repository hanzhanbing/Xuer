//
//  XRFeedbackController.h
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKPlaceHolderTextView.h"

@interface XRFeedbackController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView     *_feedbackContentView;
    IBOutlet UIView     *_contactWayView;
    TKPlaceHolderTextView   *_feedbackTextView;
    TKPlaceHolderTextView   *_contactWayTextView;
}

@end
