//
//  XRCourseListController.m
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseListController.h"
#import "XRCourseListCell.h"
#import "XRCourseInfoController.h"

#define kListCount  10
int chooseFlag = 0; //自定义控件数组

@interface XRCourseListController ()
{
    NSMutableArray *btns; //自定义控件数组
    NSString *arrchildid;
}
@end

@implementation XRCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    [self addCustomNavagationBarWithTitle:_typeInfo.name isNeedBackButton:YES];
    
    //网络数据加载
    arrchildid = _typeInfo.arrchildid;
    [self networkWithIsAdd:NO];
    
    _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (chooseFlag == 0) {
            arrchildid = _typeInfo.arrchildid;
        } else {
            XRSubTypeInfo *subTypeInfo = self.courseTypeArray[chooseFlag-1];
            arrchildid = subTypeInfo.linkageid;
        }
        [self networkWithIsAdd:NO];
    }];
    _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (chooseFlag == 0) {
            arrchildid = _typeInfo.arrchildid;
        } else {
            XRSubTypeInfo *subTypeInfo = self.courseTypeArray[chooseFlag-1];
            arrchildid = subTypeInfo.linkageid;
        }
        [self networkWithIsAdd:YES];
    }];
    [_mainTableView registerNib:[UINib nibWithNibName:@"XRCourseListCell" bundle:nil] forCellReuseIdentifier:@"XRCourseListCell"];
    
    _mainTableView.tableHeaderView = [self setTableHeaderView];
}

- (UIView *)setTableHeaderView {
    //头部背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    
    //分类数据源
    self.courseTypeArray = _typeInfo.children;
    
    //分类View布局
    int col = 3;  //将屏幕宽度划分成col份
    int j = 0; //记录多少行
    int btnW = (kScreenWidth-10*(col+1))/col; //按钮宽
    btns = [[NSMutableArray alloc]initWithCapacity:self.courseTypeArray.count];
    UIButton *button;
    for (int i = 0; i<self.courseTypeArray.count+1; i++) {
        if (i%col==0&&i!=0) {
            j++;
        }
        button = [[UIButton alloc]initWithFrame:CGRectMake((btnW+10)*(i%col)+10, 50*j+10, btnW, 40)];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(changeBtnBg:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [button setTitle:@"全部" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.000 green:0.451 blue:0.408 alpha:1.000] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor colorWithRed:0.584 green:0.729 blue:0.710 alpha:1.000].CGColor];
        } else {
            XRSubTypeInfo *subTypeInfo = self.courseTypeArray[i-1];
            [button setTitle:subTypeInfo.name forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.294 alpha:1.000] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor colorWithWhite:0.780 alpha:1.000].CGColor];
        }
        
        [btns addObject:button];
        [view addSubview:btns[i]];
    }
    
    //大家都在看View布局
    int typeViewH = (j+1)*50+20;
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, typeViewH, 200, 20)];
    tipLab.text = @"大家都在看：";
    tipLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    tipLab.font = [UIFont systemFontOfSize:16];
    [view addSubview:tipLab];
    
    //动态计算头部View的高度
    CGRect vFrame = view.frame;
    vFrame.size.height = typeViewH+25;
    view.frame = vFrame;
    
    return view;
}

- (void)changeBtnBg:(UIButton *)sender {
    _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (chooseFlag == 0) {
            arrchildid = _typeInfo.arrchildid;
        } else {
            XRSubTypeInfo *subTypeInfo = self.courseTypeArray[chooseFlag-1];
            arrchildid = subTypeInfo.linkageid;
        }
        [self networkWithIsAdd:YES];
    }];
    chooseFlag = (int)sender.tag;
    for (int i = 0; i<btns.count; i++) {
        UIButton *button = (UIButton *)btns[i];
        if (i == chooseFlag) {
            [button setTitleColor:[UIColor colorWithRed:0.000 green:0.451 blue:0.408 alpha:1.000] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor colorWithRed:0.584 green:0.729 blue:0.710 alpha:1.000].CGColor];
            NSLog(@"%@",sender.titleLabel.text);
        }else{
            [button setTitleColor:[UIColor colorWithWhite:0.294 alpha:1.000] forState:UIControlStateNormal];
            [button.layer setBorderWidth:1.0];
            [button.layer setBorderColor:[UIColor colorWithWhite:0.780 alpha:1.000].CGColor];
        }
    }
    if (chooseFlag == 0) {
        arrchildid = _typeInfo.arrchildid;
    } else {
        XRSubTypeInfo *subTypeInfo = self.courseTypeArray[chooseFlag-1];
        arrchildid = subTypeInfo.linkageid;
    }
    [self networkWithIsAdd:NO];
}

-(void)networkWithIsAdd:(BOOL)isAdd
{
    if (_dataSourceArray.count % 10 != 0 && isAdd)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无更多课程";
        [hud hide:YES afterDelay:1.2];
        [_mainTableView.footer endRefreshing];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
        int page = (int)(_dataSourceArray.count/kListCount)+1;
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_courselist withParams:@{kArrchildid:arrchildid,kPage:@(page),kCount:@(kListCount)} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            NSLog(@"%@",responseData);
            [_mainTableView.header endRefreshing];
            [_mainTableView.footer endRefreshing];
            [MBProgressHUD hideHUDForView:_contentView animated:YES];
            NSMutableArray *array = (NSMutableArray *)[XRCourseListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
            if (array.count<10) {
                _mainTableView.footer = nil;
            }
            if (isAdd)
            {
                [self.dataSourceArray addObjectsFromArray:array];
            }
            else
            {
                self.dataSourceArray = array;
            }
            
            [_mainTableView reloadData];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRCourseListCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XRCourseListCell" owner:nil options:nil] firstObject];
    }
    cell.courseListInfo = _dataSourceArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XRCourseInfoController *courseInfoC = [[XRCourseInfoController alloc] init];
    XRCourseListInfo *courseListInfo = _dataSourceArray[indexPath.row];
    courseInfoC.courseId = courseListInfo.courseId;
    [self.navigationController pushViewController:courseInfoC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    chooseFlag = 0; //还原设置
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
