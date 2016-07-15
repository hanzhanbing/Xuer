//
//  CellFactory.m
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "CellFactory.h"
#import "TextCell.h"
#import "TextLinkCell.h"
#import "TextPicLinkCell.h"

@implementation CellFactory

+ (BaseCell *)getCell:(XRMessageListInfo *)cellInfo withCellStyle:(UITableViewCellStyle)cellStyle withCellIdentifier:(NSString *)reuseIdentifier {
    BaseCell *baseCell;
    if (cellInfo.tp == TextCellType) {
        baseCell = [[TextCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    } else if (cellInfo.tp == TextLinkCellType) {
        baseCell = [[TextLinkCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    } else if (cellInfo.tp == TextPicLinkCellType) {
        baseCell = [[TextPicLinkCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    }
    return baseCell;
}

+ (NSString *)getCellIdentifier:(XRMessageListInfo *)cellInfo {
    if (cellInfo.tp == TextCellType) {
        return [TextCell getIdentifier];
    } else if (cellInfo.tp == TextLinkCellType) {
        return [TextLinkCell getIdentifier];
    } else if (cellInfo.tp == TextPicLinkCellType) {
        return [TextPicLinkCell getIdentifier];
    }
    return nil;
}

+ (CGFloat)getCellHeight:(XRMessageListInfo *)cellInfo {
    if (cellInfo.tp == TextCellType) {
        return [TextCell getHeight:cellInfo];
    } else if (cellInfo.tp == TextLinkCellType) {
        return [TextLinkCell getHeight:cellInfo];
    } else if (cellInfo.tp == TextPicLinkCellType) {
        return [TextPicLinkCell getHeight:cellInfo];
    }
    return 0;
}

@end
