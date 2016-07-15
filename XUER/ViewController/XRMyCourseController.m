//
//  XRMyCourseController.m
//  XUER
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import "XRMyCourseController.h"
#import "XRCourseListInfo.h"
#import "XRMyCourseCell.h"
#import "XRCourseInfoController.h"
#import "XRSettingController.h"
#import "XRLoginController.h"
#import "XRMessageListInfo.h"
#import "XRMyMessageCell.h"
#import "XRSystemMessageController.h"

@interface XRMyCourseController ()
{
    /*!
     *  @brief 标题的分段按钮
     */
    UISegmentedControl *segment;
}
@end

@implementation XRMyCourseController

- (void)viewWillAppear:(BOOL)animated{
    [self setViews];
}

- (void)setViews{
    _noDataView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    _noDataView.center = _mainTableView.center;
    _noDataView.hidden = YES;
    [_mainTableView addSubview:_noDataView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustomNavagationBarWithTitle:@"" isNeedBackButton:NO]; //设置标题
    [self segmentedControl]; //加载分段选择视图
    //设置按钮
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 30, 22)];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [[self getCustomView] addSubview:settingButton];
    
//    //下载按钮
//    UIButton *downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 30, 30, 22)];
//    [downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [downloadButton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
//    [[self getCustomView] addSubview:downloadButton];
    
    if (![XRConfigs share].username)
    {
        _loginView.hidden = NO;
        _contentView.hidden = YES;
        _noDataView.hidden = YES;
    }
    else {
        _loginView.hidden = YES;
        _contentView.hidden = NO;
        _noDataView.hidden = YES;
        
        [self addHeader];
    }
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucc:) name:kLoginSuccNotification object:nil]; //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucc:) name:kLogoutSuccNotification object:nil]; //注销成功
}

#pragma mark - 添加刷新视图
- (void)addHeader{
    
    _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (segment.selectedSegmentIndex==0) {  //我的课程头部刷新
            [[XRNetCenter share] sendRequestWithNetType:XRNetType_courselist withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kTaguid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@""} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
                _myCourseArray = (NSMutableArray *)[XRCourseListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
                [_mainTableView reloadData];
                [_mainTableView.header endRefreshing];
            }];
        }else{  //我的消息头部刷新
            [[XRNetCenter share] sendRequestWithNetType:XRNetType_messagelist withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kTaguid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@""} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
                _myMessageArray = (NSMutableArray *)[XRMessageListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
                if (_myMessageArray.count==0) {
                    _noDataView.hidden = NO;
                }else{
                    _noDataView.hidden = YES;
                }
                [_mainTableView reloadData];
                [_mainTableView.header endRefreshing];
            }];
//            //初始化我的消息数据(本地数据)
//            XRMessageListInfo *messageInfo = [[XRMessageListInfo alloc] init];
//            messageInfo.tm = @"3月8日";
//            messageInfo.con = @"由于您首次提交实名材料...";
//            _myMessageArray = [NSMutableArray array];
//            [_myMessageArray addObject:messageInfo];
//            
//            NSLog(@"%@",_myMessageArray);
//            
//            [_mainTableView reloadData];
//            [_mainTableView.header endRefreshing];
        }
    }];
    [_mainTableView.header beginRefreshing];
}

#pragma mark - (我的课程/我的消息)分段选择视图
- (void)segmentedControl {
    NSArray *titleNames = @[@"我的课程",@"我的消息"];
    segment = [[UISegmentedControl alloc] initWithItems:titleNames];
    segment.frame = CGRectMake((kScreenWidth-150)/2, 27, 150, 30);
    //默认选择第几个按钮
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventValueChanged];
    [[self getCustomView] addSubview:segment];
}

- (void)selectButton:(UISegmentedControl *)seg {
    [self.view endEditing:YES];
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            //我的课程
            if (![XRConfigs share].username)
            {
                _loginView.hidden = NO;
                _contentView.hidden = YES;
                _noDataView.hidden = YES;
            }
            else {
                _loginView.hidden = YES;
                _contentView.hidden = NO;
                _noDataView.hidden = YES;
                [_mainTableView.header beginRefreshing];
            }
        }
            _mainTableView.backgroundColor = [UIColor whiteColor];
            break;
        case 1:
        {
            if (![XRConfigs share].username) //判断用户是否登录
            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//                [alert show];
            } else {
                //我的消息
                _loginView.hidden = YES;
                _contentView.hidden = NO;
                [_mainTableView.header beginRefreshing];
            }
        }
            _mainTableView.backgroundColor = [UIColor colorWithRed:0.9569 green:0.9569 blue:0.9569 alpha:1.0];
            break;
        default:
            break;
    }
    
    [_mainTableView reloadData];
}

-(void)loginSucc:(NSNotification *)noti
{
    _loginView.hidden = YES;
    _contentView.hidden = NO;
    _noDataView.hidden = YES;

    if (_mainTableView.header) {
        [_mainTableView.header beginRefreshing];
    }else{
        [self addHeader];
    }
}

-(void)logoutSucc:(NSNotification *)noti
{
    _loginView.hidden = NO;
    _contentView.hidden = YES;
    _noDataView.hidden = YES;
}

-(void)settingButtonClick:(UIButton *)button
{
    XRSettingController *settingC = [[XRSettingController alloc] init];
    settingC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingC animated:YES];
}

- (IBAction)loginButtonTouchUp:(id)sender {
    XRLoginController *loginC = [[XRLoginController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
    navC.navigationBarHidden = YES;
    [self presentViewController:navC animated:NO completion:nil];
}

//#pragma mark - UIAlertViewDelegate协议
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==1) {
//        XRLoginController *loginC = [[XRLoginController alloc] init];
//        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
//        navC.navigationBarHidden = YES;
//        [self presentViewController:navC animated:NO completion:nil];
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        XRMyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRMyCourseCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRMyCourseCell" owner:nil options:nil] firstObject];
        }
        cell.courseListInfo = _myCourseArray[indexPath.row];
        return cell;
    }else{
        XRMyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRMyMessageCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRMyMessageCell" owner:nil options:nil] firstObject];
            cell.messageListInfo = _myMessageArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0) {
        return _myCourseArray.count;
    }else{
        return _myMessageArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        return 120;
    }else{
        return 77;
    }
}

/*!
 *  @brief 暂时先隐藏搜索功能
 */

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]init];
//    if (segment.selectedSegmentIndex==1&&section==0&&_myMessageArray.count>0) {
//        view.frame = CGRectMake(0, 0, kScreenWidth, 60);
//        view.backgroundColor = _mainTableView.backgroundColor;
//        
//        UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 40)];
//        bar.placeholder = @"搜索";
//        bar.searchBarStyle = UISearchBarStyleMinimal;
//        bar.barTintColor = view.backgroundColor;
//        [view addSubview:bar];
//        
//        return view;
//    }
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (segment.selectedSegmentIndex==1&&section==0&&_myMessageArray.count>0) {
//        return 60;
//    }
//    return 0.01;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        //课程详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        XRCourseInfoController *courseInfoC = [[XRCourseInfoController alloc] init];
        courseInfoC.hidesBottomBarWhenPushed = YES;
        XRCourseListInfo *courseListInfo = _myCourseArray[indexPath.row];
        courseInfoC.courseId = courseListInfo.courseId;
        [self.navigationController pushViewController:courseInfoC animated:YES];
    }else{
        //系统消息
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        XRSystemMessageController *systemMessageC = [[XRSystemMessageController alloc] init];
        systemMessageC.hidesBottomBarWhenPushed = YES;
        XRMessageListInfo *messageListInfo = _myMessageArray[indexPath.row];
        systemMessageC.tp = messageListInfo.tp;
        [self.navigationController pushViewController:systemMessageC animated:NO];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        XRCourseListInfo *info = _myCourseArray[indexPath.row];
        __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_joincourse withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kCourseid:info.courseId,kIsjoin:@"0"} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            if (status == 200)
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"取消课程成功";
                [hud hide:YES afterDelay:1.2];
                [_myCourseArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"取消课程失败";
                [hud hide:YES afterDelay:1.2];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
