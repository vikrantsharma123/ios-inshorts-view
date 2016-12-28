//
//  NewsCardView.m
//  InshortsTest
//
//  Created by Vikrant Sharma on 27/12/16.
//  Copyright © 2016 VikrantSharma. All rights reserved.
//

#import "NewsCardView.h"

@implementation NewsCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.containerView.frame = CGRectMake(self.containerX, self.containerY, self.containerWidth, self.containerHeight);
    self.containerView.translatesAutoresizingMaskIntoConstraints = YES;
}

@end
