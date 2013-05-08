//
//  ContentViewController.h
//
//  Created by Jack Humphries on 3/20/12.
//  Copyright (c) 2012 Jack Humphries. All rights reserved.
//

@class PDFScrollView;

@interface ContentViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, unsafe_unretained) CGPDFDocumentRef thePDF;

- (void)configureWithPDF:(CGPDFDocumentRef)pdf;

@end
