//
//  XRSetPasswordController.h
//  XUER
//
//  Created by 韩占禀 on 15/8/26.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRSetPasswordController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView         *_contentView;
    IBOutlet UITextField    *_passwordTextField;
    IBOutlet UIButton       *_finishButton;
}

@property (nonatomic,strong) NSString   *phoneNum;

@end
