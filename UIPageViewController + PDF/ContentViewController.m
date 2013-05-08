//
//  ContentViewController.m
//
//  Created by Jack Humphries on 3/20/12.
//  Copyright (c) 2012 Jack Humphries. All rights reserved.
//

#import "ContentViewController.h"
#import "PDFScrollView.h"

@implementation ContentViewController

- (void)configureWithPDF:(CGPDFDocumentRef)pdf {
    self.thePDF = pdf;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Create our PDFScrollView and add it to the view controller.
    CGPDFPageRef PDFPage = CGPDFDocumentGetPage(self.thePDF, [self.page intValue]);
    PDFScrollView *scrollView = [[PDFScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.drawPDFActualSize = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [scrollView setPDFPage:PDFPage];
    [self.view addSubview:scrollView];
}

@end