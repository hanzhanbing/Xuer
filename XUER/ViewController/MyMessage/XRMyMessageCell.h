//
//  XRMyMessageCell.h
//  XUER
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRMessageListInfo.h"

@interface XRMyMessageCell : UITableViewCell
{
    IBOutlet UIImageView *_iconImageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
    IBOutlet UILabel *_dateLabel;
}

@property (nonatomic , retain)XRMessageListInfo *messageListInfo;

@end
