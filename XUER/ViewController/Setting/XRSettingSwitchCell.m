//
//  XRSettingSwitchCell.m
//  XUER
//
//  Created by scsys on 16/3/29.
//  Copyright © 2016年 a. All rights reserved.
//

#import "XRSettingSwitchCell.h"
#import "AFNetworking.h"

@implementation XRSettingSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIsFirst:(BOOL)isFirst
{
    _upLineView.hidden = !isFirst;
}

-(void)setIsSwitchHidden:(BOOL)isSwitchHidden
{
    _switchBtn.hidden = isSwitchHidden;
}

-(void)setIsSegmentHidden:(BOOL)isSegmentHidden
{
    _segmentBtn.hidden = isSegmentHidden;
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.on==YES) {
        NSLog(@"开");
        if (switchBtn.tag == 100) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kWatchingByMobileNetwork];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kDownloadingByMobileNetwork];
        }
    } else {
        NSLog(@"关");
        if (switchBtn.tag == 100) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kWatchingByMobileNetwork];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kDownloadingByMobileNetwork];
        }
    }
}

- (IBAction)segmentBtn:(id)sender {
    UISegmentedControl *segmentBtn = (UISegmentedControl *)sender;
    if (segmentBtn.selectedSegmentIndex==0) {
        NSLog(@"清晰");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kDownloadingDefinition];
    } else if (segmentBtn.selectedSegmentIndex==1) {
        NSLog(@"高清");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kDownloadingDefinition];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
