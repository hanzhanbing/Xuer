//
//  TLShareView.h
//  ThirdLogin
//
//  Created by 韩占禀 on 15/8/20.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRShareCenter.h"

@interface TLShareView : UIView
{
    IBOutlet UIView     *_weiboView;
    IBOutlet UIView     *_wechatView;
    IBOutlet UIView     *_timelineView;
    IBOutlet UIView     *_qqView;
    IBOutlet UIView     *_qqZoneView;
    
    IBOutlet UIView     *_contentView;
    IBOutlet UIView     *_bgView;
}

-(void)showInView:(UIView *)view;

@end
