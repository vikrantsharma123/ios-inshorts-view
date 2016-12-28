# ios-inshorts-view
This is a UI component, written in Objective-C, that can be used for implementing a vertical swipe up-down view for next/previous cards, just like the News Inshorts App, in a iOS application.

The usage of this component is based on the familiar datasource and delegate patterns used by several other components such as *UICollectionView* and *UITableView*. In addition, it also supports re-use of views to reduce memory usage and improve performance.

## Demo Screen Video (Animated Gif)
![demo video gif](/demo_videos/vik_inshorts_demo.gif "demo_video_gif")

## Demo Screenshots
![initial](/demo_images/initial.png "initial")
![swipe_up_1](/demo_images/swipe_up_1.png "swipe_up_1")
![swipe_up_2](/demo_images/swipe_up_2.png "swipe_up_2")
![swipe_up_3](/demo_images/swipe_up_3.png "swipe_up_3")
![swipe_down](/demo_images/swipe_down.png "swipe_down")

## How to use this component?
1. Copy the files **InshortsView.h** and **InshortsView.m** into your Xcode project.
2. In your view controller code, **#import "InshortsView.h"** and implement the protocols **InshortsViewDelegate** and **InshortsViewDataSource**.
3. Check the **InshortsTest** demo application for more details on the usage.

## Implementation Details
This component internally uses a recycling pattern on 3 views, one each for current, previous and next views. The effects are achieved using the Scale and Translate transformations, applied in response to several stages of the pan gesture.

## Developer Contact
Vikrant Sharma (vikrant.sharma@gmail.com)
