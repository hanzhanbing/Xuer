//
//  XRPersonInfoView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRSettingController;
@interface XRPersonInfoView : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView    *_iconImageView;
    IBOutlet UITextField    *_nickNameTextField;
    
    IBOutlet UIView         *_textFieldBgView;
}

@property (nonatomic,strong) UIImagePickerController     *imagePickerC;
@property (nonatomic,assign) XRSettingController    *superVC;

-(void)textFieldSetNoEdit;

@end
