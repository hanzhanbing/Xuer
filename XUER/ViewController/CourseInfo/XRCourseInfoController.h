//
//  XRCourseInfoController.h
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRSectionView.h"
#import "XRCourseInfo.h"
#import "XRContentViewCell.h"
#import "XRCourseHeaderView.h"

@interface XRCourseInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView         *_contentView;
    IBOutlet UITableView    *_mainTableView;
    XRCourseHeaderView      *_headerView;
}

@property (nonatomic,strong) XRSectionView           *sectionView;

@property (nonatomic,strong) NSString   *courseId;
@property (nonatomic,strong) XRCourseInfo       *courseInfo;
@property (nonatomic,assign) XRContentViewCell  *onlyCell;
@property (nonatomic,strong) NSString   *deleteVideoId;

-(void)setContentOffsetY:(CGFloat)y;

-(void)deleteVideoWithVideoId:(NSString *)videoId;

-(void)showProgressHud;

-(void)hideProgressHud;

-(void)joinCourse;

-(void)reloadData;

@end
