//
//  BaseCell.h
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRMessageListInfo.h"

@interface BaseCell : UITableViewCell

@property (nonatomic,retain) UIButton  *linkbtn; //对外开放的链接按钮

- (void)addContentView;
- (void)setContentView:(XRMessageListInfo *)cellInfo;

+ (NSString *)getIdentifier;
+ (CGFloat)getHeight:(XRMessageListInfo *)cellInfo;

@end
