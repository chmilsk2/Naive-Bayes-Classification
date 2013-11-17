//
//  DigitTestingCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingCollectionViewController.h"
#import "DigitDetailsViewController.h"
#import "DigitCollectionViewCell.h"
#import "DigitSet.h"
#import "DigitLabelParser.h"
#import "DigitParser.h"

#define STATISTICS_BUTTON_TITLE @"Statistics"
#define DigitTestingCollectionViewCellIdentifier @"DigitTestingCollectionViewCellIdentifier"
#define TESTING_LABELS_TEXT_NAME @"testlabels"
#define TESTING_IMAGES_TEXT_NAME @"testimages"

@implementation DigitTestingCollectionViewController {
	DigitSet mDigitSet;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_statisticsButton;
	UIColor *_barTintColor;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	self = [super initWithCollectionViewLayout:layout];
	
	if (self) {
		_barTintColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
}

- (void)setUpNavigation {
	[self.navigationController.navigationBar setTintColor:_barTintColor];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItem:self.statisticsButton];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitTestingCollectionViewCellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mDigitSet.digits.size();
	
	return numberOfDigits;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitTestingCollectionViewCellIdentifier forIndexPath:indexPath];
	
	cell.delegate = self;
	cell.dataSource = self;
	
	[cell setNeedsDisplay];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE * DIGIT_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	Digit selectedDigit = mDigitSet.digits[indexPath.row];
	
	DigitDetailsViewController *digitDetailsViewController = [[DigitDetailsViewController alloc] initWithDigit:selectedDigit];
	UINavigationController *digitDetailsNavController = [[UINavigationController alloc] initWithRootViewController:digitDetailsViewController];
	
	[digitDetailsNavController setModalPresentationStyle:UIModalPresentationFormSheet];
	[digitDetailsNavController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	[self presentViewController:digitDetailsNavController animated:YES completion:nil];
}

- (void)parseDigitLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_LABELS_TEXT_NAME ofType:@"txt"];
	DigitLabelParser digitLabelParser([filePath fileSystemRepresentation]);
	mDigitSet = digitLabelParser.parseDigitLabels();
}

- (void)setUpDigitSet {
	mDigitSet.setBitShiftSizeUsingDigitSize(DIGIT_SIZE);
}

- (void)parseDigits {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_IMAGES_TEXT_NAME ofType:@"txt"];
	DigitParser digitParser([filePath fileSystemRepresentation]);
	digitParser.parseDigits(mDigitSet);
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

#pragma mark - Statistics Button

- (UIBarButtonItem *)statisticsButton {
	if (!_statisticsButton) {
		_statisticsButton = [[UIBarButtonItem alloc] initWithTitle:STATISTICS_BUTTON_TITLE
															 style:UIBarButtonItemStylePlain
															target:self
															action:@selector(statisticsButtonTouched)];
	}
	
	return _statisticsButton;
}

#pragma mark - Statistics Button Touched

- (void)statisticsButtonTouched {
	NSLog(@"Statistics button touched");
}

#pragma mark - Digit Collection View Cell Delegate

- (CGFloat)cellSize {
	return (CGFloat)DIGIT_SIZE;
}

#pragma mark - Digit Collection View Cell Data Source

- (UIColor *)pixelColorForDigitCell:(DigitCollectionViewCell *)digitCollectionViewCell Row:(NSUInteger)row col:(NSUInteger)col {
	UIColor *pixelColor;
	
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:digitCollectionViewCell];
	
	Digit digit = mDigitSet.digits[indexPath.row];
	
	char pixelChar = digit.pixelValue((int)row, (int)col);
	
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
