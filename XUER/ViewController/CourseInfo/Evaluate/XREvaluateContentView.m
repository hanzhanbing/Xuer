//
//  XREvaluateContentView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/1.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XREvaluateContentView.h"
#import "XRCourseInfoController.h"

@implementation XREvaluateContentView

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [_bgView addGestureRecognizer:tap];
    
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    _starView.starType = StarType_Big;
    [_starSuperView addSubview:_starView];
    _starView.frame = _starSuperView.bounds;
    _starView.isCanTouch = YES;
    
    _placeHolderTextView = [[TKPlaceHolderTextView alloc] initWithFrame:_textSuperView.bounds];
    [_textSuperView addSubview:_placeHolderTextView];
    _placeHolderTextView.placeholder = @"评论，100字以内";
    [_placeHolderTextView setWidthToAutoresizeScreenWidth];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(IBAction)submitButtonClick:(id)sender
{
    [self endEditing:YES];

    if (_starView.starValue != 0 && _placeHolderTextView.text.length > 0)
    {
        NSString *starStringValue = [NSString stringWithFormat:@"%.1f",_starView.starValue];
        [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_coursecommentadd withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kCid:_cid,kStar:starStringValue,kContent:_placeHolderTextView.text} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            [MBProgressHUD hideHUDForView:self.superview animated:YES];
            [self hideView];
            if (status == 200)
            {
                XRCommentInfo *mycomment = [[XRCommentInfo alloc] init];
                mycomment.star = starStringValue;
                mycomment.content = _placeHolderTextView.text;
                mycomment.tm = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
                if ([mycomment.star length] != 0)
                {
                    mycomment.realname = [XRConfigs share].realname;
                    mycomment.logo = [XRConfigs share].logo;
                    _superVC.courseInfo.mycomment = mycomment;
#warning jjjjjjj
                    if (isEditOrAdd==NO) {
                   [_superVC.courseInfo.commentArray insertObject:mycomment atIndex:0];
                    }else{
                        [_superVC.courseInfo.commentArray replaceObjectAtIndex:0 withObject:mycomment];
                    }

                    [[NSNotificationCenter defaultCenter] postNotificationName:kEvaluationSuccNotification object:nil];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kEvaluationSuccNotification object:nil];
                }
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的评价信息不完善！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
    }
}

-(void)showInView:(UIView *)view  isEditOrAdd:(NSString *)index
{
    [view addSubview:self];
    
    _bgView.alpha = 0;
    _contentView.y = self.height;


    if ([index isEqualToString:@"add"]) {
        isEditOrAdd = NO;
    }else{
        isEditOrAdd = YES;
    }

    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.333;
        _contentView.centerY = kScreenHeight/2;
    } completion:^(BOOL finished) {
//        [_placeHolderTextView becomeFirstResponder];
    }];


}

#pragma mark -UIKeyBoardNotification
-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary* info = [noti userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_contentView setY:self.height - kbSize.height - _contentView.height];
    [UIView commitAnimations];
}

-(void)starViewTap
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    _contentView.centerY = kScreenHeight/2;
//    [UIView commitAnimations];
}

-(void)hideView
{
    _bgView.alpha = 0.333;
    _contentView.y = kScreenHeight - 250;
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _contentView.y = self.height;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }];
}

@end
