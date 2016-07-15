//
//  XRAbountController.h
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRAbountController : UIViewController
{
    IBOutlet UIView         *_contentView;
    IBOutlet UIScrollView   *_scrollView;
    
    IBOutlet UIImageView    *_xuerLogoImageView;
    IBOutlet UIImageView    *_circleArcImageView;
    IBOutlet UILabel        *_versionLabel;
    IBOutlet UILabel        *_introduceLabel;
    IBOutlet UIImageView    *_qrCodeImageView;
    IBOutlet UIButton       *_checkUpdateButton;
    IBOutlet UILabel        *_copyrightLabel;
}

@end
