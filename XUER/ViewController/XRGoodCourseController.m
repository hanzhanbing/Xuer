//
//  XRGoodCourseController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRGoodCourseController.h"
#import "XRLoginController.h"
#import "XRCourseSecitonInfo.h"
#import "XRGoodCourseCell.h"
#import "XRCourseInfoController.h"
#import "XRGoodCourseSectionView.h"
#import "XRSearchController.h"
#import "XREightCourseCell.h"
#import "JSONKit.h"
#import "XRTypeInfo.h"
#import "XRBannerInfo.h"
#import "SDCycleScrollView.h"
#import "XRBannerDetailController.h"

@interface XRGoodCourseController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    UILabel *_label;
    UIView *_Testview;
    SDCycleScrollView *_cycleScrollView;
    int i;
}

@end

@implementation XRGoodCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self addHeader]; //添加刷新视图
    
    //首页图片轮播
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) imagesGroup:@[]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.dotColor = [UIColor whiteColor]; //分页控件小圆标颜色
    _cycleScrollView.pageControlDotSize = CGSizeMake(2, 2); //分页控件小圆标大小
    [_mainCollectionView addSubview:_cycleScrollView];
    
    //[_mainCollectionView registerNib:[UINib nibWithNibName:@"XRGoodCourseCell" bundle:nil] forCellWithReuseIdentifier:@"XRGoodCourseCell"];
    [_mainCollectionView registerClass:[XRGoodCourseCell class] forCellWithReuseIdentifier:@"XRGoodCourseCell"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"XRGoodCourseSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XRGoodCourseSectionView"];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"XRBannerView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XRBannerView"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"XREightCourseCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XREightCourseCell"];
}

#pragma mark - 添加刷新视图
- (void)addHeader{
    _mainCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //清空数据源
        i = 0;
        [_bannerArr removeAllObjects];
        [_goodCourseTypeArray removeAllObjects];
        [_goodCourseArray removeAllObjects];
        //图片轮播接口
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_bannerlist withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            _bannerArr = [XRBannerInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
            _cycleScrollView.imageURLStringsGroup = [self handleUrl];
            [_mainCollectionView reloadData];
            i++;
            if (i==3) {
                [_mainCollectionView.header endRefreshing];
                _mainCollectionView.header = nil;
            }
        }];
        
        //精品课程类型接口（7个）
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_typelist withParams:@{kIds:@"1"} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            if (status == 200)
            {
                _goodCourseTypeArray = [XRTypeInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
                [_mainCollectionView reloadData];
                i++;
                if (i==3) {
                    [_mainCollectionView.header endRefreshing];
                    _mainCollectionView.header = nil;
                }
            }
        }];
        
        //精品课程接口
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_indexlist withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            if (status == 200)
            {
                _goodCourseArray = [XRCourseSecitonInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
                [_mainCollectionView reloadData];
                i++;
                if (i==3) {
                    [_mainCollectionView.header endRefreshing];
                    _mainCollectionView.header = nil;
                }
            }
        }];
    }];
    [_mainCollectionView.header beginRefreshing];
}

//设置轮播图
#pragma mark - SDCycleScrollViewDelegate代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    XRBannerInfo *info = _bannerArr[index];
    XRBannerDetailController *bannerDetailC = [[XRBannerDetailController alloc] init];
    bannerDetailC.url = info.url;
    bannerDetailC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bannerDetailC animated:YES];
}

#pragma mark - 处理 获取 图片的地址
- (NSArray *)handleUrl{
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *list = [NSMutableArray arrayWithArray:_bannerArr];
    for (int i = 0; i < list.count; i ++) {
        XRBannerInfo *info = list[i];
        [data addObject:info.img];
    }
    return data;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_bannerArr.count>0) {

        CGFloat maxH = 180;
        CGFloat hh = scrollView.contentOffset.y;
        if (hh<=0 && hh>-maxH) {
            _cycleScrollView.frame = CGRectMake(0, hh, kScreenWidth, 150-hh);
        }
        //设置最大拉伸程度
        if (hh<=-maxH) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -maxH);
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XRGoodCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRGoodCourseCell" forIndexPath:indexPath];
    XRCourseSecitonInfo *info = _goodCourseArray[indexPath.section-2];
    cell.courseItemInfo = info.courseArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        XRBannerView *firstBannerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XRBannerView" forIndexPath:indexPath];
        //firstBannerView.bannerArr = _bannerArr;
        //firstBannerView.superVC = self;
        return firstBannerView;
    } else if (indexPath.section == 1)
    {
        XREightCourseCell *eightCourseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XREightCourseCell" forIndexPath:indexPath];
        eightCourseView.dataSourceArray = _goodCourseTypeArray;
        eightCourseView.superVC = self;
        return eightCourseView;
    }
    XRGoodCourseSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XRGoodCourseSectionView" forIndexPath:indexPath];
    sectionView.sectionInfo = _goodCourseArray[indexPath.section-2];
    return sectionView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgW = (kScreenWidth-8*3)/2;
    return CGSizeMake(imgW, imgW/2+50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(kScreenWidth, _bannerArr.count>0?150:0);
    }
    else if (section == 1)
    {
        return CGSizeMake(kScreenWidth, _goodCourseTypeArray.count>0?180:0);
    }
    return CGSizeMake(kScreenWidth, 44);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 0;
    }
    XRCourseSecitonInfo *info = _goodCourseArray[section-2];
    return info.courseArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _goodCourseArray.count+2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.001;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0)
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if (section == 1)
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 7, 0, 7);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![XRConfigs share].username) //判断用户是否登录
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//        [alert show];
//    } else {
        XRCourseInfoController *courseInfoC = [[XRCourseInfoController alloc] init];
        courseInfoC.hidesBottomBarWhenPushed = YES;
        
        XRCourseSecitonInfo *sectonInfo = _goodCourseArray[indexPath.section-2];
        XRCourseItemInfo *itemInfo = sectonInfo.courseArray[indexPath.row];
        courseInfoC.courseId = itemInfo.courseid;
        [self.navigationController pushViewController:courseInfoC animated:YES];
//    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotoSearchController:(id)sender
{
    XRSearchController *searchC = [[XRSearchController alloc] init];
    searchC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchC animated:YES];
}

@end
