//
//  DigitCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTrainingCollectionViewController.h"
#import "DigitTestingCollectionViewController.h"
#import "DigitDetailsViewController.h"
#import "DigitParser.h"
#import "DigitLabelParser.h"
#import "DigitSet.h"

#define DIGIT_TRAINING_NAVIGATION_ITEM_TITLE @"Training"
#define TRAIN_BUTTON_TITLE @"Train"
#define TEST_BUTTON_TITLE @"Test"
#define TRAINING_LABELS_TEXT_NAME @"traininglabels"
#define TRAINING_IMAGES_TEXT_NAME @"trainingimages"
#define DigitTrainingCollectionViewCellIdentifier @"DigitTrainingCollectionViewCellIdentifier"

@implementation DigitTrainingCollectionViewController {
	DigitSet mDigitSet;
	UIBarButtonItem *_trainButton;
	UIBarButtonItem *_testButton;
	UIColor *_barTintColor;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	self = [super initWithCollectionViewLayout:layout];
	
	if (self) {
		_barTintColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_TRAINING_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setRightBarButtonItems:@[self.testButton, self.trainButton]];
	[self.navigationController.navigationBar setTintColor:_barTintColor];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitTrainingCollectionViewCellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mDigitSet.digits.size();
	
	return numberOfDigits;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitTrainingCollectionViewCellIdentifier forIndexPath:indexPath];

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
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TRAINING_LABELS_TEXT_NAME ofType:@"txt"];
	DigitLabelParser digitLabelParser([filePath fileSystemRepresentation]);
	mDigitSet = digitLabelParser.parseDigitLabels();
}

- (void)setUpDigitSet {
	mDigitSet.setBitShiftSizeUsingDigitSize(DIGIT_SIZE);
}

- (void)parseDigits {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TRAINING_IMAGES_TEXT_NAME ofType:@"txt"];
	DigitParser digitParser([filePath fileSystemRepresentation]);
	digitParser.parseDigits(mDigitSet);
}

#pragma mark - Train Button

- (UIBarButtonItem *)trainButton {
	if (!_trainButton) {
		_trainButton = [[UIBarButtonItem alloc] initWithTitle:TRAIN_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(trainButtonTouched)];
	}
	
	return _trainButton;
}

#pragma mark - Train Button Touched

- (void)trainButtonTouched {
	NSLog(@"Train button touched");
}

#pragma mark - Test Button

- (UIBarButtonItem *)testButton {
	if (!_testButton) {
		_testButton = [[UIBarButtonItem alloc] initWithTitle:TEST_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testButtonTouched)];
	}
	
	return _testButton;
}

#pragma mark - Test Button Touched

- (void)testButtonTouched {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	DigitTestingCollectionViewController *digitTestingCollectionViewController = [[DigitTestingCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:digitTestingCollectionViewController];
	
	[self presentViewController:navController animated:YES completion:nil];
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

@end
