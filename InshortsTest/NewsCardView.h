//
//  NewsCardView.h
//  InshortsTest
//
//  Created by Vikrant Sharma on 27/12/16.
//  Copyright © 2016 VikrantSharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCardView : UIView
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) int containerWidth;
@property (nonatomic) int containerHeight;
@property (nonatomic) int containerX;
@property (nonatomic) int containerY;

@end
