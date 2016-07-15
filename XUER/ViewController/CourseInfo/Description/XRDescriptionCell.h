//
//  XRDescriptionCell.h
//  XUER
//
//  Created by scsys on 16/4/21.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRCourseInfoController;
@interface XRDescriptionCell : UITableViewCell
{
    IBOutlet UILabel *_introduceLabel;
}

@property (nonatomic,assign) XRCourseInfoController *superVC;
@property (nonatomic,copy)   NSString *introduce;

+(CGFloat)heightWithIntroduce:(NSString *)introduce;

@end
