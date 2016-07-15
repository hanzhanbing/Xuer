//
//  XRAllCourseController.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRTypeInfo.h"

@interface XRAllCourseController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIImageView        *_xuerLogoImageView;
    IBOutlet UIView             *_searchView;
    IBOutlet UIButton           *_searchButton;
    IBOutlet UITextField        *_searchTextField;
    IBOutlet UIImageView        *_searchBgImageView;
    
    IBOutlet UIView             *_contentView;
    IBOutlet UICollectionView   *_collectionView;
}

@property (nonatomic,strong) NSArray    *dataSourceArray;


@end
