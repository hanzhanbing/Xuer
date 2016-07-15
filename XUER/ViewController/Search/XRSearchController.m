//
//  XRSearchController.m
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRSearchController.h"
#import "XRCourseListInfo.h"
#import "XRCourseListCell.h"
#import "XRCourseInfoController.h"
#import "XRSearchResultController.h"

#define kSearchCount    10

@interface XRSearchController ()
{
    NSMutableArray *btns; //自定义控件数组
    NSUserDefaults *defaults;
}
@end

@implementation XRSearchController

- (void)viewWillAppear:(BOOL)animated {
    self.dataSourceArray = [ NSMutableArray arrayWithArray:[defaults objectForKey:@"searchHisArr"]];
    [_mainTableView reloadData];
    _searchTextField.text = nil;
    if (self.dataSourceArray.count>0) {
        _mainTableView.tableFooterView = [self setTableFooterView];
    } else {
        _mainTableView.tableFooterView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBgImageView.image = [UIImage resizableImage:@"searchBg.png"];
    //[_searchTextField becomeFirstResponder];
    
    defaults = [NSUserDefaults standardUserDefaults];
    self.dataSourceArray = [NSMutableArray array];
    
//    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _mainTableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0); // 设置端距，这里表示separator离左边和右边均0像素
    
    //热门搜索关键词接口
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_hotsearchwords withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        self.hotSourceArray = (NSMutableArray *)responseData;
        _mainTableView.tableHeaderView = [self setTableHeaderView];
        [_mainTableView reloadData];
        
        //隐藏键盘手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
        [_mainTableView.tableHeaderView addGestureRecognizer:tap];
    }];
}

- (UIView *)setTableHeaderView {
    //头部背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    
    //热门搜索
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    tipLab.text = @"热门搜索";
    tipLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    tipLab.font = [UIFont systemFontOfSize:17];
    [view addSubview:tipLab];
    
    //分类View布局
    int col = 4;  //将屏幕宽度划分成col份
    int j = 0; //记录多少行
    int btnW = (kScreenWidth-10*(col+1))/col; //按钮宽
    btns = [[NSMutableArray alloc]initWithCapacity:self.hotSourceArray.count];
    UIButton *button;
    for (int i = 0; i<self.hotSourceArray.count; i++) {
        if (i%col==0&&i!=0) {
            j++;
        }
        button = [[UIButton alloc]initWithFrame:CGRectMake((btnW+10)*(i%col)+10, 45*j+38, btnW, 35)];
        button.tag = i;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(searchCourse:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.hotSourceArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.294 alpha:1.000] forState:UIControlStateNormal];
        [button.layer setCornerRadius:5];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[UIColor colorWithWhite:0.780 alpha:1.000].CGColor];
        
        [btns addObject:button];
        [view addSubview:btns[i]];
    }
    
    int typeViewH = (j+1)*45+20;
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, typeViewH+20, kScreenWidth, 20)];
    grayView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    [view addSubview:grayView];
    
    //搜索历史
    UILabel *historyLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayView.frame)+10, 200, 20)];
    historyLab.text = @"搜索历史";
    historyLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    historyLab.font = [UIFont systemFontOfSize:17];
    [view addSubview:historyLab];
    
    //动态计算头部View的高度
    CGRect vFrame = view.frame;
    vFrame.size.height = typeViewH+80;
    view.frame = vFrame;
    
    return view;
}

- (UIView *)setTableFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    UIButton *clearSearchH = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-130)/2, 5, 130, 40)];
    clearSearchH.showsTouchWhenHighlighted = YES;
    [clearSearchH setTitle:@"清空历史记录" forState:UIControlStateNormal];
    clearSearchH.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearSearchH setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    [clearSearchH.layer setCornerRadius:5];
    [clearSearchH.layer setMasksToBounds:YES];
    [clearSearchH.layer setBorderWidth:1.0];
    [clearSearchH.layer setBorderColor:[UIColor colorWithWhite:0.780 alpha:1.000].CGColor];
    [clearSearchH addTarget:self action:@selector(clearSearchHis) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clearSearchH];
    
    return view;
}

-(void)clearSearchHis {
    [self.dataSourceArray removeAllObjects];
//    [defaults setObject:self.dataSourceArray forKey:@"searchHisArr"];
    [defaults removeObjectForKey:@"searchHisArr"];
    [_mainTableView reloadData];
    
    if (self.dataSourceArray.count>0) {
        _mainTableView.tableFooterView = [self setTableFooterView];
    } else {
        _mainTableView.tableFooterView = nil;
    }
}

-(void)searchCourse:(UIButton *)btn
{
    [self.view endEditing:YES]; //结束编辑设置
    //跳转到搜索结果展示页面
    XRSearchResultController *searchResultC = [[XRSearchResultController alloc] init];
    searchResultC.searchKey = btn.titleLabel.text;
    [self.navigationController pushViewController:searchResultC animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //将搜索的关键字加入到搜索历史数组中
    [self.dataSourceArray addObject:textField.text];
    [defaults setObject:self.dataSourceArray forKey:@"searchHisArr"];
    //跳转到搜索结果展示页面
    XRSearchResultController *searchResultC = [[XRSearchResultController alloc] init];
    searchResultC.searchKey = textField.text;
    [self.navigationController pushViewController:searchResultC animated:YES];
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRSearchListCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XRSearchListCell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"searchButton.png"];
    
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到搜索结果展示页面
    XRSearchResultController *searchResultC = [[XRSearchResultController alloc] init];
    searchResultC.searchKey = _dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:searchResultC animated:YES];
}

-(IBAction)goback:(id)sender
{
    [self pop];
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyboard {
    [self.view endEditing:YES]; //结束编辑设置
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
