//
//  XRBannerView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/3.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRBannerView.h"
#import "XRBannerInfo.h"
#import "XRBannerDetailController.h"
#import "XRGoodCourseController.h"

@implementation XRBannerView

-(void)awakeFromNib
{
    // Initialization code
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) imagesGroup:@[]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.dotColor = [UIColor whiteColor]; //分页控件小圆标颜色
    _cycleScrollView.pageControlDotSize = CGSizeMake(2, 2); //分页控件小圆标大小
    [self addSubview:_cycleScrollView];
}

-(void)setBannerArr:(NSMutableArray *)bannerArr {
    if (_bannerArr != bannerArr)
    {
        _bannerArr = bannerArr;
        _cycleScrollView.imageURLStringsGroup = [self handleUrl];
    }
}

//设置轮播图
#pragma mark - SDCycleScrollViewDelegate代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    XRBannerInfo *info = _bannerArr[index];
    XRBannerDetailController *bannerDetailC = [[XRBannerDetailController alloc] init];
    bannerDetailC.url = info.url;
    bannerDetailC.hidesBottomBarWhenPushed = YES;
    [self.superVC.navigationController pushViewController:bannerDetailC animated:YES];
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

@end
