//
//  XRSystemMessageController.m
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "XRSystemMessageController.h"
#import "XRMessageListInfo.h"
#import "CellFactory.h"
#import "XRBannerDetailController.h"

@interface XRSystemMessageController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_cellInfoArray;
}
@end

@implementation XRSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addCustomNavagationBarWithTitle:@"系统消息" isNeedBackButton:YES]; //设置标题
    
    [self addTableView];
    
    [self addHeader]; //加载网络数据
    
    //[self initData];(本地数据测试)
}

#pragma mark - 加载UITableView
- (void)addTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
}

#pragma mark - 添加刷新视图
- (void)addHeader{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"%d",self.tp);
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_messageinfo withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kTaguid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kTp:[NSString stringWithFormat:@"%d",self.tp]} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            _cellInfoArray = (NSMutableArray *)[XRMessageListInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }];
    }];
    [_tableView.header beginRefreshing];
}

#pragma mark - 初始化数据
- (void)initData {
    //初始化消息详情数据(本地数据)
    _cellInfoArray = [NSMutableArray array];
    
    for (int i=0; i<3; i++) {
        if (i==0) {
            XRMessageListInfo *cellInfo = [[XRMessageListInfo alloc] init];
            cellInfo.tp = TextPicLinkCellType;
            cellInfo.tm = @"03-08 4:34";
            cellInfo.title = @"关于教学那些事";
            cellInfo.con = @"小学教师教学故事时候说：“谁爱孩子，孩子就爱谁，只有爱孩子的人...”小学教师教学故事时候说：“谁爱孩子，孩子就爱谁，只有爱孩子的人...”";
            cellInfo.link_con = @"工作圈实名动态";
            cellInfo.link_logo = @"http://img05.tooopen.com/images/20140707/sy_65015952591.jpg";
            cellInfo.href = @"http://www.baidu.com";
            [_cellInfoArray addObject:cellInfo];
        }
        if (i==1) {
            XRMessageListInfo *cellInfo = [[XRMessageListInfo alloc] init];
            cellInfo.tp = TextLinkCellType;
            cellInfo.tm = @"03-08 4:34";
            cellInfo.title = @"关于教学那些事";
            cellInfo.con = @"小学教师教学故事时候说：“谁爱孩子，孩子就爱谁，只有爱孩子的人...”";
            cellInfo.link_con = @"工作圈实名动态";
            cellInfo.link_logo = @"";
            cellInfo.href = @"http://www.baidu.com";
            [_cellInfoArray addObject:cellInfo];
        }
        if (i==2) {
            XRMessageListInfo *cellInfo = [[XRMessageListInfo alloc] init];
            cellInfo.tp = TextCellType;
            cellInfo.tm = @"03-08 4:34";
            cellInfo.title = @"";
            cellInfo.con = @"由于您首次提交职业成名材料通过认证，获得5点影响力的奖励";
            cellInfo.link_con = @"";
            cellInfo.link_logo = @"";
            cellInfo.href = @"";
            [_cellInfoArray addObject:cellInfo];
        }
    }
}

#pragma mark - UITableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XRMessageListInfo *cellInfo = _cellInfoArray[indexPath.row];
    return [CellFactory getCellHeight:cellInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XRMessageListInfo *cellInfo = _cellInfoArray[indexPath.row];
    //编译时、运行时
    NSString *cellIndentifier = [CellFactory getCellIdentifier:cellInfo];
    BaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!baseCell) {
        baseCell = [CellFactory getCell:cellInfo withCellStyle:UITableViewCellStyleDefault withCellIdentifier:cellIndentifier];
        baseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [baseCell.linkbtn addTarget:self action:@selector(jumpWeb:) forControlEvents:UIControlEventTouchUpInside];
        baseCell.linkbtn.tag = 1000+indexPath.row;
    }
    
    [baseCell setContentView:cellInfo];
    
    return baseCell;
}

#pragma mark - 链接跳转
-(void)jumpWeb:(UIButton *)btn {
    NSInteger index = btn.tag-1000;
    XRMessageListInfo *cellInfo = _cellInfoArray[index];
    XRBannerDetailController *bannerDetailC = [[XRBannerDetailController alloc] init];
    bannerDetailC.url = cellInfo.href;
    bannerDetailC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
