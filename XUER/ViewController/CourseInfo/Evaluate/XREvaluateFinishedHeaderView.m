//
//  XREvaluateFinishedHeaderView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/2.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XREvaluateFinishedHeaderView.h"
#import "XREvaluateContentView.h"
#import "XRCourseInfoController.h"

@implementation XREvaluateFinishedHeaderView

-(void)awakeFromNib
{
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    [_starSuperView addSubview:_starView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluateSucc:) name:kEvaluationSuccNotification object:nil];
}

-(void)evaluateSucc:(NSNotification *)noti
{
    _starView.starValue = [_superVC.courseInfo.mycomment.star floatValue];
}

-(void)setStarValue:(float)starValue
{
    _starView.starValue = starValue;
}

-(IBAction)editButtonClick:(id)sender
{
    XREvaluateContentView *evaluateView = [[[NSBundle mainBundle] loadNibNamed:@"XREvaluateContentView" owner:nil options:nil] firstObject];
    evaluateView.frame = [UIScreen mainScreen].bounds;
    evaluateView.superVC = _superVC;
    evaluateView.cid = _superVC.courseId;
    [evaluateView showInView:_superVC.view isEditOrAdd:@"edit"];
}

@end
