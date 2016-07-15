//
//  XRStarView.h
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

enum StarType
{
    StarType_Normal,
    StarType_Big,
};

@interface XRStarView : UIView
{
    IBOutlet UIImageView    *_grayStarImageView;
    IBOutlet UIView         *_redStarView;
    IBOutlet UIImageView    *_redStarImageView;
}

@property (nonatomic) enum StarType starType;
@property (nonatomic) float starValue;
@property (nonatomic) BOOL  isCanTouch;

@end
