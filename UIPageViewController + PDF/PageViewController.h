//
//  PageViewController.h
//
//  Created by Jack Humphries on 3/20/12
//  Copyright (c) 2012 Jack Humphries. All rights reserved.
//

#import "ContentViewController.h"
#import "ViewController.h"

@class ContentViewController, UIPrintInteractionController;

@interface PageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *thePageViewController;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalPages;

- (void)configureWithPDFAtPath:(NSString *)path;

@end
