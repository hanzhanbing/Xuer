//
//  XRSettingDefaultCell.h
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRSettingDefaultCell : UITableViewCell
{
    IBOutlet UIImageView    *_upLineView;
}

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,assign) BOOL   isFirst;

@end