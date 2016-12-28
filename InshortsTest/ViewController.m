//
//  ViewController.m
//  InshortsTest
//
//  Created by Vikrant Sharma on 08/12/16.
//  Copyright © 2016 VikrantSharma. All rights reserved.
//

#import "ViewController.h"
#import "InshortsView.h"
#import "NewsCardView.h"

@interface ViewController () <InshortsViewDelegate, InshortsViewDataSource>
@property (strong, nonnull) InshortsView* inshortsView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.inshortsView = [[InshortsView alloc] initWithFrame:self.view.frame];
    self.inshortsView.dataSource = self;
    self.inshortsView.delegate = self;
    
    [self.view addSubview:self.inshortsView];
}


- (NSInteger)numberOfItemsInInshortsView:(InshortsView *)inshortsView
{
    return 5;
}

- (UIView *)inshortsView:(InshortsView *)inshortsView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < 0 || index >= 5)
        return nil;

    UIView* temp;
    if (view) {
        NSLog(@"reusing view");
        temp = view;
    }
    else {
        temp = [[[NSBundle mainBundle] loadNibNamed:@"NewsCardView" owner:self options:nil] objectAtIndex:0];
        NewsCardView *v = (NewsCardView*)temp;
        v.containerWidth = inshortsView.frame.size.width - 32;
        v.containerHeight = inshortsView.frame.size.height - 40;
        v.containerX = 16;
        v.containerY = 20;
        temp.frame = CGRectMake(0, 0,inshortsView.frame.size.width, inshortsView.frame.size.height);
    }
    return temp;
}

- (void)inshortsViewCurrentItemIndexDidChange:(InshortsView *)inshortsView
{
    NSLog(@"inshortsViewCurrentItemIndexDidChange");
    NSLog(@"%ld", (long)inshortsView.currentItemIndex);
}


- (void)inshortsView:(InshortsView *)inshortsView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"didSelectItemAtIndex %ld", (long)index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
