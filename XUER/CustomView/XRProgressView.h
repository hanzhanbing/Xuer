//
//  XRProgressView.h
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRProgressView : UIView
{
    IBOutlet UIView  *_progressView;
}

@property (nonatomic,assign) CGFloat progress;

@end
