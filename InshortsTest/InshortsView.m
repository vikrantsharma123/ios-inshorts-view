//
//  InshortsView.m
//  InshortsTest
//
//  Created by Vikrant Sharma on 12/12/16.
//  Copyright © 2016 VikrantSharma. All rights reserved.
//

#import "InshortsView.h"

@interface InshortsView()
@property (strong, nonatomic) UIView* previousView;
@property (strong, nonatomic) UIView* currentView;
@property (strong, nonatomic) UIView* nextView;
@property (strong, nonatomic) UIPanGestureRecognizer* pangr;
@property (strong, nonatomic) UITapGestureRecognizer* tapgr;
@end

@implementation InshortsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.previousView = nil;
        self.currentView = nil;
        self.nextView = nil;
        self.pangr = nil;
        self.tapgr = nil;
        self.numberOfItems = 0;
        self.currentItemIndex = 0;
        self.dataSource = nil;
        self.delegate = nil;
    }
    return self;
}

- (void)reloadData
{
    if (self.currentView) {
        [self.currentView removeGestureRecognizer:self.pangr];
        [self.currentView removeGestureRecognizer:self.tapgr];
        [self.currentView removeFromSuperview];
    }
    if (self.previousView) {
        [self.previousView removeFromSuperview];
    }
    if (self.nextView) {
        [self.nextView removeFromSuperview];
    }
    if (self.dataSource) {
        self.numberOfItems = [self.dataSource numberOfItemsInInshortsView:self];
        if (self.numberOfItems > 0) {
            if ( (self.currentItemIndex >= 0) && (self.currentItemIndex < self.numberOfItems) ) {
                self.currentView = [self.dataSource inshortsView:self viewForItemAtIndex:self.currentItemIndex reusingView:self.currentView];
                if (self.currentView) {
                    self.pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
                    [self.currentView addGestureRecognizer:self.pangr];
                    self.tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                    [self.currentView addGestureRecognizer:self.tapgr];
                }
            }
            if ( ( (self.currentItemIndex-1) >= 0) && ( (self.currentItemIndex -1) < self.numberOfItems) ) {
                self.previousView = [self.dataSource inshortsView:self viewForItemAtIndex:self.currentItemIndex-1 reusingView:self.previousView];
                if (self.previousView) {
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                }
            }
            if ( ( (self.currentItemIndex+1) >= 0) && ( (self.currentItemIndex +1) < self.numberOfItems) ) {
                self.nextView = [self.dataSource inshortsView:self viewForItemAtIndex:self.currentItemIndex+1 reusingView:self.nextView];
                if (self.nextView) {
                    self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }
                
            }
            if (self.nextView) {
                [self addSubview:self.nextView];
            }
            if (self.currentView) {
                [self addSubview:self.currentView];
            }
            if (self.previousView) {
                [self addSubview:self.previousView];
            }
        }
    }
}

- (void)setDataSource:(id<InshortsViewDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        if (_dataSource)
        {
            [self reloadData];
        }
    }
}

- (void)viewPanned:(id)sender
{
    UIPanGestureRecognizer* pangr = (UIPanGestureRecognizer*)sender;
    CGPoint translationInView = [pangr translationInView:pangr.view];
    
    CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self].y);
    
    if (pangr.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.15;
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (translationInView.y < 0) {
                if (self.nextView) {
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, translationInView.y);
                    self.nextView.transform = CGAffineTransformMakeScale(0.9 - (translationInView.y)/(10*self.nextView.frame.size.height), 0.9 - (translationInView.y)/(10*self.nextView.frame.size.height));
                }
                else {
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, translationInView.y/3);
                }
            }
            else {
                if (self.previousView) {
                    self.currentView.transform = CGAffineTransformMakeScale(1.0 - (translationInView.y)/(10*self.currentView.frame.size.height), 1.0 - (translationInView.y)/(10*self.currentView.frame.size.height));
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, translationInView.y - self.previousView.frame.size.height);
                }
                else {
                    self.currentView.transform = CGAffineTransformMakeScale(1.0 - (translationInView.y/3)/(10*self.currentView.frame.size.height), 1.0 - (translationInView.y/3)/(10*self.currentView.frame.size.height));
                }
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    if (pangr.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//        NSLog(@"velocity = %f", velocityY);
        
        if (translationInView.y < 0) {
            // user was swiping up and the gesture has now ended
            if (self.nextView && ((translationInView.y < -self.currentView.frame.size.height/2) || (velocityY < -200))) {
                // treat the swipe-up gesture as completed
                // CurrentIndex has now increased by one
                CGFloat animationDuration = 0.25f;
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, -self.currentView.frame.size.height);
                    self.nextView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    [self sendSubviewToBack:self.previousView];
                    [self.currentView removeGestureRecognizer:self.pangr];
                    [self.currentView removeGestureRecognizer:self.tapgr];
                    
                    UIView* temp = self.previousView;
                    self.previousView = self.currentView;
                    self.currentView = self.nextView;
                    self.nextView = temp;
                    
                    [self.nextView removeFromSuperview];
                    self.currentItemIndex++;
                    if (self.currentItemIndex >= self.numberOfItems) {
                        self.currentItemIndex = self.numberOfItems-1;
                    }
                    temp = nil;
                    if (self.dataSource) {
                        if ( (self.currentItemIndex+1) < self.numberOfItems) {
                            temp = [self.dataSource inshortsView:self viewForItemAtIndex:self.currentItemIndex+1 reusingView:self.nextView];
                        }
                    }
                    self.nextView = temp;
                    if (self.nextView) {
                        [self insertSubview:self.nextView atIndex:0];
                        self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                    [self.currentView addGestureRecognizer:self.pangr];
                    [self.currentView addGestureRecognizer:self.tapgr];
                    if (self.delegate) {
                        [self.delegate inshortsViewCurrentItemIndexDidChange:self];
                    }
                }];
                
            }
            else {
                // treat the swipe-up gesture as cancelled
                // Restore
                CGFloat animationDuration = 0.25f;
                
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, 0);
                    self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                } completion:^(BOOL finished) {
//                    NSLog(@"complete");
                    
                }];
                
            }
        }
        else {
            // user was swiping down, and the gesture has now ended
            if (!self.previousView || (translationInView.y < (self.currentView.frame.size.height/2) && (velocityY < 200))) {
                // treat the swipe-down gesture as cancelled
                // Restore
                CGFloat animationDuration = 0.25f;
                
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.currentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                } completion:^(BOOL finished) {
//                    NSLog(@"complete");
                    
                }];
                
                
            }
            else {
                // treat the swipe-down gesture as completed
                //  CurrentIndex has now decreased by one
                CGFloat animationDuration = 0.25f;
                
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.currentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
//                    NSLog(@"complete");
                    self.nextView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    [self bringSubviewToFront:self.nextView];
                    [self.currentView removeGestureRecognizer:self.pangr];
                    [self.currentView removeGestureRecognizer:self.tapgr];
                    
                    UIView* temp = self.nextView;
                    self.nextView = self.currentView;
                    self.currentView = self.previousView;
                    self.previousView = temp;
                    
                    [self.previousView removeFromSuperview];
                    self.currentItemIndex--;
                    if (self.currentItemIndex < 0) {
                        self.currentItemIndex = 0;
                    }
                    temp = nil;
                    if (self.dataSource) {
                        if ( (self.currentItemIndex-1) >= 0) {
                            temp = [self.dataSource inshortsView:self viewForItemAtIndex:self.currentItemIndex-1 reusingView:self.previousView];
                        }
                    }
                    self.previousView = temp;
                    if (self.previousView) {
                        [self insertSubview:self.previousView atIndex:2];
                        self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                    }
                    
                    self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    [self.currentView addGestureRecognizer:self.pangr];
                    [self.currentView addGestureRecognizer:self.tapgr];
                    if (self.delegate) {
                        [self.delegate inshortsViewCurrentItemIndexDidChange:self];
                    }
                }];
                
            }
        }
    }
    if (pangr.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.15;

        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (translationInView.y < 0) {
                if (self.nextView) {
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, translationInView.y);
                    self.nextView.transform = CGAffineTransformMakeScale(0.9 - (translationInView.y)/(10*self.nextView.frame.size.height), 0.9 - (translationInView.y)/(10*self.nextView.frame.size.height));
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                }
                else {
                    self.currentView.transform = CGAffineTransformMakeTranslation(0, translationInView.y/3);
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, -self.previousView.frame.size.height);
                }
            }
            else {
                if (self.previousView) {
                    self.currentView.transform = CGAffineTransformMakeScale(1.0 - (translationInView.y)/(10*self.currentView.frame.size.height), 1.0 - (translationInView.y)/(10*self.currentView.frame.size.height));
                    self.previousView.transform = CGAffineTransformMakeTranslation(0, translationInView.y - self.previousView.frame.size.height);
                    self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }
                else {
                    self.currentView.transform = CGAffineTransformMakeScale(1.0 - (translationInView.y/3)/(10*self.currentView.frame.size.height), 1.0 - (translationInView.y/3)/(10*self.currentView.frame.size.height));
                    self.nextView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }
            }
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)viewTapped:(id)sender
{
//    NSLog(@"viewTapped");
    if (self.delegate) {
        [self.delegate inshortsView:self didSelectItemAtIndex:self.currentItemIndex];
    }
}

@end
