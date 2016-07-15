//
//  UIPlaceHolderTextView.m
//  TKCommonLib
//
//  Created by luo bin on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TKPlaceHolderTextView.h"

@implementation TKPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize backgroundImage;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.backgroundImage = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundImage = [[UIImage imageNamed:@"TKCommonLib.bundle/EGOTextView/textViewBackground.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.backgroundColor = [UIColor clearColor];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        self.backgroundImage = [[UIImage imageNamed:@"TKCommonLib.bundle/EGOTextView/textViewBackground.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        self.backgroundColor = [UIColor clearColor];
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    CGFloat alpha = [self viewWithTag:999].alpha;
    
    if([[self text] length] == 0)
    {
        if (alpha != 1) {
            [UIView animateWithDuration:0.25 animations:^{
                [[self viewWithTag:999] setAlpha:1];
            }];
        }
    }
    else
    {
        if (alpha != 0) {
            [UIView animateWithDuration:0.25 animations:^{
                [[self viewWithTag:999] setAlpha:0];
            }];
        }
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)setbackgroudImage {
    self.backgroundImage = nil;
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundImage drawInRect:rect];
    
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode =UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        
        if (self.textAlignment == NSTextAlignmentRight)
        {
            placeHolderLabel.x = self.width - placeHolderLabel.width-8;
        }
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
