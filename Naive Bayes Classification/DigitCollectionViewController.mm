//
//  DigitCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitCollectionViewController.h"
#import "DigitParser.h"
#import "DigitLabelParser.h"
#import "DigitSet.h"

#define TRAINING_LABELS_TEXT_NAME @"traininglabels"
#define TRAINING_IMAGES_TEXT_NAME @"trainingimages"
#define DIGIT_SIZE_MULTIPLIER 6.0f
#define DigitCollectionViewCellIdentifier @"DigitCollectionViewCellIdentifier"

@implementation DigitCollectionViewController {
	DigitSet mDigitSet;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setUpCollection];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitCollectionViewCellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mDigitSet.digits.size();
	
	return numberOfDigits;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DigitCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DigitCollectionViewCellIdentifier forIndexPath:indexPath];

	cell.delegate = self;
	cell.dataSource = self;
	
	[cell setNeedsDisplay];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger digitCellSize = DIGIT_SIZE * DIGIT_SIZE_MULTIPLIER;
	
	return CGSizeMake(digitCellSize, digitCellSize);
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
