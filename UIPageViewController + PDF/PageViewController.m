//
//  PageViewController.m
//
//  Created by Jack Humphries on 3/20/12.
//  Copyright (c) 2012 Jack Humphries. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()
@end

@implementation PageViewController

- (void)configureWithPDFAtPath:(NSString *)path {

    if (self.PDFDocument)
    {
        CFRelease(self.PDFDocument);
        self.PDFDocument = nil;
    }

    NSURL *pdfUrl = [NSURL fileURLWithPath:path];
    self.PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfUrl);
    self.totalPages = (NSInteger)CGPDFDocumentGetNumberOfPages(self.PDFDocument);

    self.modelArray = [NSMutableArray array];

    for (int index = 1; index <= self.totalPages; index++) {
        [self.modelArray addObject:@(index)];
    }
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    [contentViewController configureWithPDF:self.PDFDocument];
    
    self.currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)viewController page]];
    
    if (self.currentIndex == 0) {
        return nil;
    }
    
    contentViewController.page = self.modelArray[self.currentIndex - 1];
    
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    [contentViewController configureWithPDF:self.PDFDocument];
    
    //get the current page
    self.currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)viewController page]];
    
    //detect if last page
    //remember that in an array, the first index is 0
    //so if there are three pages, the array will contain the following pages: 0, 1, 2
    //page 2 is the last page, so 3 - 1 = 2 (totalPages - 1 = last page)
    if (self.currentIndex == self.totalPages - 1) {
        return nil;
    }
    
    contentViewController.page = self.modelArray[self.currentIndex + 1];
        
    return contentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.totalPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}


#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = [self.thePageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self.thePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.thePageViewController.doubleSided = NO;

    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.thePageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.thePageViewController.delegate = self;
    self.thePageViewController.dataSource = self;

    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    [contentViewController configureWithPDF:self.PDFDocument];

    contentViewController.page = self.modelArray[0];
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [self.thePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:self.thePageViewController];
    [self.view addSubview:self.thePageViewController.view];
    self.thePageViewController.view.frame = self.view.bounds;
    [self.thePageViewController didMoveToParentViewController:self];

    self.view.backgroundColor = [UIColor underPageBackgroundColor];
}

-(void)dealloc {
    if (self.PDFDocument) {
        CFRelease(self.PDFDocument);
    }
}

@end
