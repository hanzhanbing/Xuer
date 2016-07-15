//
//  XRSearchResultController.m
//  XUER
//
//  Created by lamco on 16/3/23.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "XRSearchResultController.h"
#import "XRCourseListInfo.h"
#import "XRCourseListCell.h"
#import "XRCourseInfoController.h"

#define kSearchCount    10

@interface XRSearchResultController ()

@end

@implementation XRSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustomNavagationBarWithTitle:@"搜索结果" isNeedBackButton:YES];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_searchlist withParams:@{kKeyword:self.searchKey,kPage:@"1",kCount:@(kSearchCount)} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            [hud hide:YES];
            self.dataSourceArray = [XRCourseListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
            [_mainTableView reloadData];
            [_mainTableView.header endRefreshing];
            [self reloadFooterView];
        }];
    }];
    
    [_mainTableView.header beginRefreshing];
}

-(void)reloadFooterView
{
    if (_dataSourceArray.count % kSearchCount != 0)
    {
        _mainTableView.footer = nil;
    }
    else
    {
        _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMore];
        }];
    }
}

-(void)loadMore
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
    int page = (int)(_dataSourceArray.count/kSearchCount)+1;
    
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_searchlist withParams:@{kKeyword:self.searchKey?self.searchKey:@"",kPage:@(page),kCount:@(kSearchCount)} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        [hud hide:YES];
        [_mainTableView.footer endRefreshing];
        NSMutableArray *array = (NSMutableArray *)[XRCourseListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
        [self.dataSourceArray addObjectsFromArray:array];
        [_mainTableView reloadData];
        
        [self reloadFooterView];
    }];
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
    XRCourseInfoController *courseInfoC = [[XRCourseInfoController alloc] init];
    XRCourseListInfo *courseListInfo = _dataSourceArray[indexPath.row];
    courseInfoC.courseId = courseListInfo.courseId;
    [self.navigationController pushViewController:courseInfoC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
