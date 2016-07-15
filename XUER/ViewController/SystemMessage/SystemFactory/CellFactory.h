//
//  CellFactory.h
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCell.h"
#import "XRMessageListInfo.h"

@interface CellFactory : NSObject

+ (BaseCell *)getCell:(XRMessageListInfo *)cellInfo withCellStyle:(UITableViewCellStyle)cellStyle withCellIdentifier:(NSString *)reuseIdentifier;

+ (NSString *)getCellIdentifier:(XRMessageListInfo *)cellInfo;

+ (CGFloat)getCellHeight:(XRMessageListInfo *)cellInfo;

@end
