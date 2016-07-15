//
//  XRPersonInfoView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRPersonInfoView.h"
#import "XRSettingController.h"
#import "XRLoginController.h"

@implementation XRPersonInfoView

-(void)awakeFromNib
{
    _iconImageView.layer.cornerRadius = _iconImageView.width/2;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageTap:)];
    [_iconImageView addGestureRecognizer:tapGes];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[XRConfigs share].logo] placeholderImage:[UIImage imageNamed:@"defaultIcon.png"]];
    _nickNameTextField.text = [XRConfigs share].realname;
    
    [self textFieldSetNoEdit];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldSetNoEdit)];
    [self addGestureRecognizer:tap];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *realname = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (realname)
    {
        [textField resignFirstResponder];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_superVC.view animated:YES];
        hud.labelText = @"修改昵称中";
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_useredit withParams:@{kUsername:[XRConfigs share].username,kRealname:realname} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            if (status == 200)
            {
                [[XRConfigs share] setUserDic:responseData];
                hud.labelText = @"修改成功";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:1.2];
            }
            else
            {
                hud.labelText = @"修改失败";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:1.2];
            }
            [self textFieldSetNoEdit];
        }];
    }
    return YES;
}

-(IBAction)textFieldSetEditing
{
    if (![XRConfigs share].username) //判断用户是否登录
    {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//        [alert show];
//        __weak MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.superVC.view animated:YES];
//        hud.labelText = @"请先登录";
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.2];
    } else {
        _textFieldBgView.hidden = NO;
        _nickNameTextField.userInteractionEnabled = YES;
        [_nickNameTextField becomeFirstResponder];
    }
}

-(void)textFieldSetNoEdit
{
    [_nickNameTextField resignFirstResponder];
    _nickNameTextField.text = [XRConfigs share].realname;
    _textFieldBgView.hidden = YES;
    _nickNameTextField.userInteractionEnabled = NO;
}

-(void)iconImageTap:(UITapGestureRecognizer *)tap
{
    [self textFieldSetNoEdit];
    if (![XRConfigs share].username) //判断用户是否登录
    {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//        [alert show];
//        __weak MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.superVC.view animated:YES];
//        hud.labelText = @"请先登录";
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.2];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传一个头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"从摄像头选择", nil];
        [sheet showInView:_superVC.view];
    }
}

#pragma mark - UIAlertViewDelegate协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
    }
}

-(UIImagePickerController *)imagePickerC
{
    if (!_imagePickerC)
    {
        _imagePickerC = [[UIImagePickerController alloc] init];
        _imagePickerC.delegate = self;
        _imagePickerC.allowsEditing = YES;
        _imagePickerC.videoQuality = UIImagePickerControllerQualityType640x480;
    }
    
    return _imagePickerC;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            self.imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [_superVC presentViewController:self.imagePickerC animated:YES completion:nil];
        }
    }
    else if (buttonIndex == actionSheet.firstOtherButtonIndex+1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [_superVC presentViewController:self.imagePickerC animated:YES completion:nil];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_superVC.view animated:YES];
    hud.labelText = @"上传中";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        UIImage *iconImage = [editedImage imageScaledToSize:CGSizeMake(200, 200)];
        
        NSString *filePath = [XRFilePath filePathWithType:XRFilePathType_IconPath withFileName:nil];
        [UIImageJPEGRepresentation(iconImage, 0.75) writeToFile:filePath atomically:YES];
        
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_useredit withParams:@{kUsername:[XRConfigs share].username} withImagePath:filePath withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            if (status == 200)
            {
                hud.labelText = @"上传成功";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:1.2];
                _iconImageView.image = iconImage;
            }
            else
            {
                hud.labelText = @"上传失败";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:1.2];
            }
        }];
    });
}

@end
