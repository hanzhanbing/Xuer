//
//  XRCourseInfoController.m
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseInfoController.h"
#import "XRCourseHeaderView.h"
#import "XRContentViewCell.h"
#import "TLShareView.h"
#import "XRCourseNoJoinFooterView.h"
#import "XRCourseJoinedFooterView.h"
#import "XRTypeInfo.h"

@interface XRCourseInfoController ()
{
    XRCourseNoJoinFooterView *_footerView;
    XRCourseJoinedFooterView *_joinedFooterView;
}

@end

@implementation XRCourseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"XRCourseHeaderView" owner:nil options:nil] firstObject];
    _mainTableView.tableHeaderView = _headerView;
    _mainTableView.hidden = YES;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _contentView.frame = [UIScreen mainScreen].bounds;
    _mainTableView.frame = _contentView.bounds;
    _sectionView = [[[NSBundle mainBundle] loadNibNamed:@"XRSectionView" owner:nil options:nil] firstObject];
    _sectionView.superVC = self;

    [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_courseinfo withParams:@{kId:_courseId,kTaguid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@""} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        NSLog(@"%@",responseData);
        _courseInfo = [XRCourseInfo objectWithKeyValues:responseData];
        if ([_courseInfo.mycomment.star length] != 0)
        {
            
            _courseInfo.mycomment.logo = [XRConfigs share].logo;
            [_courseInfo.commentArray insertObject:_courseInfo.mycomment atIndex:0];
            
        }
        
        _onlyCell.courseInfo = _courseInfo;
        
        _headerView.courseInfo = _courseInfo;
        
        [MBProgressHUD hideHUDForView:_contentView animated:YES];
        _mainTableView.hidden = NO;
        if ([XRConfigs share].username) //判断用户是否登录
        {
            if (_courseInfo.isjoin.intValue == 0)
            {
                _footerView = [[[NSBundle mainBundle] loadNibNamed:@"XRCourseNoJoinFooterView" owner:nil options:nil] firstObject];
                [_footerView setWidthToAutoresizeScreenWidth];
                
                _footerView.superVC = self;
                
                _mainTableView.height = kScreenHeight-_footerView.height;
                [_contentView addSubview:_footerView];
                _footerView.y = [_mainTableView getFrame_Bottom];
            }
            else
            {
                [self addJoinedFooterView];
            }
        } else {
            _footerView = nil;
            _mainTableView.height = kScreenHeight;
        }
    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_courseinfo withParams:@{kId:_courseId,kTaguid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@""} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
//        _courseInfo = [XRCourseInfo objectWithKeyValues:responseData];
//        if ([_courseInfo.mycomment.star length] != 0)
//        {
//
//            _courseInfo.mycomment.logo = [XRConfigs share].logo;
//            [_courseInfo.commentArray insertObject:_courseInfo.mycomment atIndex:0];
//
//        }
//
//        _onlyCell.courseInfo = _courseInfo;
//
//        _headerView.courseInfo = _courseInfo;
//
//        [MBProgressHUD hideHUDForView:_contentView animated:YES];
//        _mainTableView.hidden = NO;
//        if ([XRConfigs share].username) //判断用户是否登录
//        {
//            if (_courseInfo.isjoin.intValue == 0)
//            {
//                _footerView = [[[NSBundle mainBundle] loadNibNamed:@"XRCourseNoJoinFooterView" owner:nil options:nil] firstObject];
//                [_footerView setWidthToAutoresizeScreenWidth];
//
//                _footerView.superVC = self;
//
//                _mainTableView.height = kScreenHeight-_footerView.height;
//                [_contentView addSubview:_footerView];
//                _footerView.y = [_mainTableView getFrame_Bottom];
//            }
//            else
//            {
//                [self addJoinedFooterView];
//            }
//        } else {
//            _footerView = nil;
//            _mainTableView.height = kScreenHeight;
//        }
//    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [_mainTableView reloadData];
}

-(void)reloadData
{
    [_mainTableView reloadData];
}

-(void)addJoinedFooterView
{
    if (_footerView)
    {
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _joinedFooterView = [[[NSBundle mainBundle] loadNibNamed:@"XRCourseJoinedFooterView" owner:nil options:nil] firstObject];
    [_joinedFooterView setWidthToAutoresizeScreenWidth];
    _joinedFooterView.superVC = self;

    for (int i = 0; i < _courseInfo.directoryArray.count; i++)
    {
        XRDirectoryInfo *dirInfo = _courseInfo.directoryArray[i];
        if (dirInfo.isstudied.boolValue == 0 && dirInfo.mv_url.length>0)
        {
            _joinedFooterView.directoryInfo = dirInfo;
            break;
        }
    }
    if (!_joinedFooterView.directoryInfo)
    {
        _joinedFooterView.directoryInfo = [_courseInfo.directoryArray lastObject];
    }

    _mainTableView.height = kScreenHeight-_joinedFooterView.height;
    [_contentView addSubview:_joinedFooterView];
    _joinedFooterView.y = [_mainTableView getFrame_Bottom];
}

-(IBAction)backButtonClick:(id)sender
{
    [self pop];
}

-(IBAction)shareButtonClick:(id)sender
{
    TLShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"TLShareView" owner:nil options:nil] firstObject];
    [shareView showInView:self.view];
}

-(void)setContentOffsetY:(CGFloat)y
{
    //    if (y > -_headerView.height && y < 0)
    //    {
    //        _mainTableView.contentOffset = CGPointMake(0, y+_headerView.height);
    //    }
}

-(void)deleteVideoWithVideoId:(NSString *)videoId
{
    _deleteVideoId = videoId;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"是否删除该下载内容" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *videoPath = [XRFilePath filePathWithType:XRFilePathType_CCVideo withFileName:_deleteVideoId];
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                [_mainTableView reloadData];
            }
        });
    }
}

-(void)joinCourse
{
    __weak MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_joincourse withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kCourseid:_courseId,kIsjoin:@"1"} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        if (status == 200)
        {
            hud.labelText = @"已参加此课程";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.2];
            
            [self addJoinedFooterView];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:CanCommentCourse object:nil];
        }
    }];
}

-(void)showProgressHud
{
    [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
}

-(void)hideProgressHud
{
    [MBProgressHUD hideHUDForView:_contentView animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRContentViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XRContentViewCell" owner:nil options:nil] firstObject];
        _onlyCell = cell;
    }

    [cell setIndex:1];
    cell.superVC = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight-224-50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 46;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _sectionView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
