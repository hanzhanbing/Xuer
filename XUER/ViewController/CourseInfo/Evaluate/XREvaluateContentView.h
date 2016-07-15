//
//  XREvaluateContentView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/1.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRStarView.h"
#import "TKPlaceHolderTextView.h"
#import "XRCourseInfo.h"

@class XRCourseInfoController;
@interface XREvaluateContentView : UIView
{
    IBOutlet UIView *_bgView;
    IBOutlet UIView *_contentView;
    
    IBOutlet UIView *_starSuperView;
    XRStarView      *_starView;
    
    IBOutlet UIView *_textSuperView;
    TKPlaceHolderTextView   *_placeHolderTextView;
    BOOL isEditOrAdd;//默认是添加 NO
}

@property (nonatomic,strong) NSString   *cid;//要评论的课程id
@property (nonatomic,assign) XRCourseInfoController   *superVC;


-(void)showInView:(UIView *)view  isEditOrAdd:(NSString *)index;

-(void)hideView;

@end
