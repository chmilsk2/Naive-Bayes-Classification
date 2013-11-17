//
//  DigitDetailsViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitDetailsViewController.h"
#import "DigitDetailsView.h"

#define DIGIT_DETAILS_NAVIGATION_ITEM_TITLE @"Details"

@implementation DigitDetailsViewController {
	Digit mDigit;
	DigitDetailsView *_digitDetailsView;
	UIBarButtonItem *_cancelButton;
}

- (id)initWithDigit:(Digit)digit {
	self = [super init];
	
	if (self) {
		mDigit = digit;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
}

- (void)viewDidLayoutSubviews {
	[self.view addSubview:self.digitDetailsView];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_DETAILS_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
}

- (DigitDetailsView *)digitDetailsView {
	if (!_digitDetailsView) {
		_digitDetailsView = [[DigitDetailsView alloc] initWithFrame:self.view.frame];
		
		[_digitDetailsView setDataSource:self];
		[_digitDetailsView setDelegate:self];
		
		[_digitDetailsView setUpView];
	}
	
	return _digitDetailsView;
}

#pragma mark - Cancel Button

- (UIBarButtonItem *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTouched)];
	}
	
	return _cancelButton;
}

#pragma mark - Cancel Button Touched

- (void)cancelButtonTouched {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Digit Details View Delegate

- (CGFloat)navigationBarHeight {
	CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
	
	return navBarHeight;
}

#pragma mark - Digit Details View Data Source

- (NSInteger)digitClass {
	NSInteger digitClass = mDigit.digitClass();
	
	return digitClass;
}

- (UIColor *)pixelColorForDigitView:(DigitDetailsView *)digitDetailsView Row:(NSUInteger)row col:(NSUInteger)col {
	UIColor *pixelColor;
	
	char pixelChar = mDigit.pixelValue((int)row, (int)col);
	
	if (pixelChar == ' ') {
		pixelColor = [UIColor whiteColor];
	}
	
	else if (pixelChar == '+') {
		pixelColor = [UIColor grayColor];
	}
	
	else if (pixelChar == '#') {
		pixelColor = [UIColor blackColor];
	}
	
	return pixelColor;
}

#pragma mark - Digit Details View Delegate

- (CGFloat)digitSize {
	return (CGFloat)DIGIT_SIZE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
