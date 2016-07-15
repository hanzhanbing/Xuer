//
//  XRSettingSwitchCell.h
//  XUER
//
//  Created by scsys on 16/3/29.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRSettingSwitchCell : UITableViewCell
{
    IBOutlet UIImageView *_upLineView;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBtn;

@property (nonatomic,assign) BOOL   isFirst;
@property (nonatomic,assign) BOOL   isSwitchHidden;
@property (nonatomic,assign) BOOL   isSegmentHidden;

@end
