//
//  XRContentViewCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRContentViewCell.h"
//#import "XRIntroduceCell.h"
#import "XRDescriptionCell.h"
#import "XRDirectoryCell.h"
#import "XREvaluateCell.h"
#import "XRCourseInfoController.h"
#import "DWCustomPlayerViewController.h"
#import "XRLoginController.h"

@implementation XRContentViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    // Initialization code
    [_scrollView setWidthToAutoresizeScreenWidth];
    if ([XRConfigs share].username) //判断用户是否登录
    {
        _scrollView.height = kScreenHeight-224-50-30;
    } else {
        _scrollView.height = kScreenHeight-224-30;
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _introduceTableView = [[UITableView alloc] initWithFrame:_scrollView.bounds style:UITableViewStylePlain];
    _introduceTableView.delegate = self;
    _introduceTableView.dataSource = self;
    [_scrollView addSubview:_introduceTableView];
    _introduceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_introduceTableView setWidthToAutoresizeScreenWidth];
    
    _directoryTableView = [[UITableView alloc] initWithFrame:_scrollView.bounds style:UITableViewStylePlain];
    _directoryTableView.delegate = self;
    _directoryTableView.dataSource = self;
    _directoryTableView.x = kScreenWidth;
    [_scrollView addSubview:_directoryTableView];
    _directoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_directoryTableView setWidthToAutoresizeScreenWidth];
    
    _evaluateTableView = [[UITableView alloc] initWithFrame:_scrollView.bounds style:UITableViewStylePlain];
    _evaluateTableView.delegate = self;
    _evaluateTableView.dataSource = self;
    _evaluateTableView.x = kScreenWidth*2;
    [_scrollView addSubview:_evaluateTableView];
    _evaluateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_evaluateTableView setWidthToAutoresizeScreenWidth];
    
    _evaluateHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XREvaluateHeaderView" owner:nil options:nil] firstObject];
    _evaluateHeaderView.width = 200;
//    [_evaluateHeaderView setWidthToAutoresizeScreenWidth];
//    _evaluateTableView.tableHeaderView = _evaluateHeaderView;
    
    _evaluateFinishedHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"XREvaluateFinishedHeaderView" owner:nil options:nil] firstObject];
//    [_evaluateFinishedHeaderView setWidthToAutoresizeScreenWidth];
//    _evaluateTableView.tableHeaderView = _evaluateFinishedHeaderView;
    
    _scrollView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evaluateSucc:) name:kEvaluationSuccNotification object:nil];
}

-(void)evaluateSucc:(NSNotification *)noti
{
    _evaluateTableView.tableHeaderView = _evaluateFinishedHeaderView;
    _evaluateFinishedHeaderView.starValue = _courseInfo.mycomment.star.floatValue;
    [_evaluateTableView reloadData];
}

-(void)setSuperVC:(XRCourseInfoController *)superVC
{
    if (_superVC != superVC)
    {
        _superVC = superVC;
        _evaluateHeaderView.superVC = superVC;
        _evaluateFinishedHeaderView.superVC = _superVC;
    }
}

-(void)setCourseInfo:(XRCourseInfo *)courseInfo
{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canComment) name:CanCommentCourse object:nil];;

    if (_courseInfo != courseInfo)
    {
        _courseInfo = courseInfo;
        [_introduceTableView reloadData];
        [_directoryTableView reloadData];
        [_evaluateTableView reloadData];

        if (courseInfo.mycomment.star)
        {
            _evaluateTableView.tableHeaderView = _evaluateFinishedHeaderView;
            _evaluateFinishedHeaderView.starValue = _courseInfo.mycomment.star.floatValue;

        }
        else
        {
            _evaluateTableView.tableHeaderView = _evaluateHeaderView;
            if ([_courseInfo.isjoin integerValue]==0) {
                _evaluateTableView.tableHeaderView.userInteractionEnabled = NO;
            }else{
                 _evaluateTableView.tableHeaderView.userInteractionEnabled = YES;
            }
        }
    }
}


- (void)canComment{
   _evaluateTableView.tableHeaderView.userInteractionEnabled = YES;
}

-(void)setIndex:(NSInteger)index
{
    [_scrollView setContentOffset:CGPointMake(index*kScreenWidth, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        if (scrollView.contentOffset.x < kScreenWidth * 0.5)
        {
            _superVC.sectionView.selectedIndex = 0;
        }
        else if (scrollView.contentOffset.x < kScreenWidth * 1.5)
        {
            _superVC.sectionView.selectedIndex = 1;
        }
        else
        {
            _superVC.sectionView.selectedIndex = 2;
        }
    }
    else if (scrollView == _introduceTableView || scrollView == _directoryTableView || scrollView == _evaluateTableView)
    {
        [_superVC setContentOffsetY:scrollView.contentOffset.y];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _introduceTableView)
    {
        //return _courseInfo.teacherArray.count;
        return 1;
    }
    else if (tableView == _directoryTableView)
    {
        return _courseInfo.directoryArray.count;
    }
    else
    {
        return _courseInfo.commentArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _introduceTableView)
    {
//        XRIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRIntroduceCell"];
//        if (!cell)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRIntroduceCell" owner:nil options:nil] firstObject];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        }
//        cell.superVC = _superVC;
//        cell.teacherInfo = _courseInfo.teacherArray[indexPath.row];
        
        XRDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRDescriptionCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRDescriptionCell" owner:nil options:nil] firstObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.superVC = _superVC;
        cell.introduce = _courseInfo.introduce;
        return cell;
    }
    else if (tableView == _directoryTableView)
    {
        XRDirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRDirectoryCell"];
//        if (!cell)
//        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRDirectoryCell" owner:nil options:nil] firstObject];
//        }
        cell.superVC = _superVC;
        cell.directoryInfo = _courseInfo.directoryArray[indexPath.row];
        return cell;
    }
    else
    {
        XREvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XREvaluateCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XREvaluateCell" owner:nil options:nil] firstObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.superVC = _superVC;
        cell.commentInfo = _courseInfo.commentArray[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _introduceTableView)
    {
        //return [XRIntroduceCell heightWithTeacherInfo:_courseInfo.teacherArray[indexPath.row]];
        return [XRDescriptionCell heightWithIntroduce:_courseInfo.introduce];
    }
    else if (tableView == _directoryTableView)
    {
        return 50;
    }
    else
    {
        return 78;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _directoryTableView)
    {
//        if (![XRConfigs share].username) //判断用户是否登录
//        {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，观看视频前请先登录" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//            [alert show];
//        } else {
        XRDirectoryInfo *dirInfo = _courseInfo.directoryArray[indexPath.row];
        if (dirInfo.mv_url.length>0) {

            NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kWatchingByMobileNetwork];
            NSInteger status = setting.length>0?[setting integerValue]:0; //0:关闭 1:打开
            if (status == 0 && [XRConfigs isMobileNetwork]==YES) {
                [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在wifi环境下观看视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
            } else {
                DWCustomPlayerViewController *player = [[DWCustomPlayerViewController alloc] init];
                player.videoId = dirInfo.videoId;
                player.videoTitle = dirInfo.title;
                player.courseInfo = _courseInfo;
                player.dirInfo = dirInfo;
                player.hidesBottomBarWhenPushed = YES;
                [_superVC.navigationController pushViewController:player animated:NO];
            }
        }
//        }
    }
}

#pragma mark - UIAlertViewDelegate协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
