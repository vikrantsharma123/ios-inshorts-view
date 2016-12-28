//
//  InshortsView.h
//  InshortsTest
//
//  Created by Vikrant Sharma on 12/12/16.
//  Copyright © 2016 VikrantSharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InshortsViewDataSource, InshortsViewDelegate;

@interface InshortsView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData;

@property (nonatomic, weak) id<InshortsViewDataSource> dataSource;
@property (nonatomic, weak) id<InshortsViewDelegate> delegate;
@property (nonatomic) NSInteger numberOfItems;
@property (nonatomic) NSInteger currentItemIndex;


@end

@protocol InshortsViewDataSource <NSObject>

- (NSInteger)numberOfItemsInInshortsView:(InshortsView *)inshortsView;
- (UIView *)inshortsView:(InshortsView *)inshortsView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@end


@protocol InshortsViewDelegate <NSObject>
@optional
- (void)inshortsViewCurrentItemIndexDidChange:(InshortsView *)inshortsView;
- (void)inshortsView:(InshortsView *)inshortsView didSelectItemAtIndex:(NSInteger)index;
@end
