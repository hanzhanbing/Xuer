//
//  XRAllCourseController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRAllCourseController.h"
#import "XRAllCourseCell.h"
#import "XRCourseListController.h"
#import "XRSearchController.h"

@interface XRAllCourseController ()

@end

@implementation XRAllCourseController

-(void)viewLayout
{
    [_searchView setWidthToAutoresizeScreenWidth];
    [_searchButton setWidthToAutoresizeScreenWidth];
    [_searchTextField setWidthToAutoresizeScreenWidth];
    [_searchBgImageView setWidthToAutoresizeScreenWidth];
    
    [_contentView setWidthToAutoresizeScreenWidth];
    [_contentView setHeightToAutoresizeScreenHeight];
    [_collectionView setWidthToAutoresizeScreenWidth];
    [_collectionView setHeightToAutoresizeScreenHeight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewLayout];

    [_collectionView registerNib:[UINib nibWithNibName:@"XRAllCourseCell" bundle:nil] forCellWithReuseIdentifier:@"XRAllCourseCell"];
    
    [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_typelist withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        if (status == 200)
        {
            [MBProgressHUD hideHUDForView:_contentView animated:YES];
            self.dataSourceArray = [XRTypeInfo objectArrayWithKeyValuesArray:(NSArray *)responseData];
            //NSLog(@"%@",self.dataSourceArray);
            [_collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XRAllCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XRAllCourseCell" forIndexPath:indexPath];
    cell.typeInfo = _dataSourceArray[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-20)/3.0, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XRCourseListController *courseListC = [[XRCourseListController alloc] init];
    courseListC.hidesBottomBarWhenPushed = YES;
    courseListC.typeInfo = _dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:courseListC animated:YES];
}

-(IBAction)gotoSearchController:(id)sender
{
    XRSearchController *searchC = [[XRSearchController alloc] init];
    searchC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
