//
//  XRSectionView.m
//  XUER
//
//  Created by 韩占禀 on 15/9/7.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRSectionView.h"
#import "XRCourseInfoController.h"

#define kButtonTag  120

@implementation XRSectionView

-(void)awakeFromNib
{
    //初始化默认选择第几项
    self.selectedIndex = 1;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        
        _introduceButton.selected = NO;
        _directoryButton.selected = NO;
        _evaluateButton.selected = NO;
        
        UIButton *selectedButton = (UIButton *)[self viewWithTag:kButtonTag+_selectedIndex];
        selectedButton.selected = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            _lineView.x = selectedButton.x;
        }];
    }
}

-(IBAction)introduceButtonClicked:(id)sender
{
    [_superVC.onlyCell setIndex:0];
}

-(IBAction)directoryButtonClicked:(id)sender
{
    [_superVC.onlyCell setIndex:1];
}

-(IBAction)commentButtonClicked:(id)sender
{
    [_superVC.onlyCell setIndex:2];
}

@end
