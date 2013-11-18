//
//  DigitTestingCollectionViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingCollectionViewController.h"
#import "DigitDetailsViewController.h"
#import "DigitTestingOperation.h"
#import "DigitCollectionViewCell.h"
#import "DigitSet.h"
#import "DigitLabelParser.h"
#import "DigitParser.h"
#import "DigitStatistics.h"
#import "QueuePool.h"
#import "DigitClassificaitonRule.h"
#import "DigitClassificaitonRule.h"

#define DIGIT_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION 2.0
#define DIGIT_TESTING_NAVIGATION_ITEM_TITLE @"Testing"
#define TEST_BUTTON_TITLE @"Test"
#define STATISTICS_BUTTON_TITLE @"Statistics"
#define DigitTestingCollectionViewCellIdentifier @"DigitTestingCollectionViewCellIdentifier"
#define TESTING_LABELS_TEXT_NAME @"testlabels"
#define TESTING_IMAGES_TEXT_NAME @"testimages"

@implementation DigitTestingCollectionViewController {
	DigitSet mTrainingDigitSet;
	DigitSet mTestingDigitSet;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_testButton;
	UIBarButtonItem *_statisticsButton;
	UIProgressView *_progressView;
}

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)flowLayout trainingDigitSet:(DigitSet)trainingDigitSet {
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		mTrainingDigitSet = trainingDigitSet;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self setUpProgressView];
	[self parseDigitLabels];
	[self setUpDigitSet];
	[self parseDigits];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:DIGIT_TESTING_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.statisticsButton, self.testButton] animated:YES];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[DigitCollectionViewCell class] forCellWithReuseIdentifier:DigitTestingCollectionViewCellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger numberOfDigits = mTestingDigitSet.digits.size();
	
	return numberOfDigits;
}

- (void)setUpProgressView {
	[self.navigationController.navigationBar addSubview:self.progressView];
}

- (UIProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		[_progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - _progressView.frame.size.height, self.view.frame.size.width, _progressView.frame.size.height)];
		[_progressView setAlpha:0.0];
	}
	
	return _progressView;
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
	Digit selectedDigit = mTestingDigitSet.digits[indexPath.row];
	
	DigitDetailsViewController *digitDetailsViewController = [[DigitDetailsViewController alloc] initWithDigit:selectedDigit];
	UINavigationController *digitDetailsNavController = [[UINavigationController alloc] initWithRootViewController:digitDetailsViewController];
	
	[digitDetailsNavController setModalPresentationStyle:UIModalPresentationFormSheet];
	[digitDetailsNavController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	[self presentViewController:digitDetailsNavController animated:YES completion:nil];
}

- (void)parseDigitLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_LABELS_TEXT_NAME ofType:@"txt"];
	DigitLabelParser digitLabelParser([filePath fileSystemRepresentation]);
	mTestingDigitSet = digitLabelParser.parseDigitLabels();
}

- (void)setUpDigitSet {
	mTestingDigitSet.setBitShiftSizeUsingDigitSize(DIGIT_SIZE);
}

- (void)parseDigits {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:TESTING_IMAGES_TEXT_NAME ofType:@"txt"];
	DigitParser digitParser([filePath fileSystemRepresentation]);
	digitParser.parseDigits(mTestingDigitSet);
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

#pragma mark - Test Button 

- (UIBarButtonItem *)testButton {
	if (!_testButton) {
		_testButton = [[UIBarButtonItem alloc] initWithTitle:TEST_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testButtonTouched)];
	}
	
	return _testButton;
}

#pragma mark - Test Button Touched 

- (void)testButtonTouched {
	NSLog(@"Test button touched");
	
	// configure classification rule
	ClassificationRule classificationRule = ClassificationRuleMaximumAPosteriori;
	
	DigitTestingOperation *digitTestingOperation = [[DigitTestingOperation alloc] initWithTestDigitSet:mTestingDigitSet trainingDigitSet:mTrainingDigitSet classificationRule:classificationRule];
	[digitTestingOperation setDelegate:self];
	
	digitTestingOperation.digitTestingOperationCompletionBlock = ^(DigitSet testedDigitSet) {
		NSLog(@"finished testing");
		
		mTestingDigitSet = testedDigitSet;
		
		[self.collectionView reloadData];
		
		[self didFinishUpdatingProgressView];
	};
	
	[[QueuePool sharedQueuePool].queue addOperation:digitTestingOperation];
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
	
	DigitStatistics digitStatistics;
	
	int successCounts[NUMBER_OF_DIGIT_CLASSES];
	int confusionMatrixCount[NUMBER_OF_DIGIT_CLASSES][NUMBER_OF_DIGIT_CLASSES];
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int successCount = 0;
		int confusionCount = 0;
		
		successCounts[classIndexR] = successCount;
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			confusionMatrixCount[classIndexR][classIndexC] = confusionCount;
		}
	}
	
	int digitIndex = 0;
	
	for (auto it : mTestingDigitSet.digits) {
		int classifiedDigitClass = mTestingDigitSet.digits[digitIndex].digitClass();
		int correctDigitClass = mTestingDigitSet.digitLabels[digitIndex];
		
		if (classifiedDigitClass == correctDigitClass) {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeCorrect);
			successCounts[classifiedDigitClass]++;
		}
		
		else {
			mTestingDigitSet.digits[digitIndex].setClassificationType(ClassificationTypeIncorrect);
		}
						  
		// percentage of images in class r that are classified as class c
		confusionMatrixCount[correctDigitClass][classifiedDigitClass]++;
		
		digitIndex++;
	}
	
	int totalNumberOfInstances = 0;
	int overallSuccessCount = 0;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		int totalNumberOfInstancesFromClass = mTestingDigitSet.frequencyMap[classIndexR];
		
		totalNumberOfInstances += totalNumberOfInstancesFromClass;
		overallSuccessCount += successCounts[classIndexR];
		
		double successRate = (double)successCounts[classIndexR]/(double)totalNumberOfInstancesFromClass;
		
		digitStatistics.setSuccessRateForClassIndex(classIndexR, successRate);
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			double confusionRate = (double)confusionMatrixCount[classIndexR][classIndexC]/(double)totalNumberOfInstancesFromClass;
		
			digitStatistics.setConfusionRateForTestImagesFromClassRClassifiedAsClassC(classIndexR, classIndexC, confusionRate);
		}
	}
	
	double overallSuccessRate = (double)overallSuccessCount/(double)totalNumberOfInstances;
	digitStatistics.setOverallSuccessRate(overallSuccessRate);
	
	digitStatistics.printSuccessRates();
	digitStatistics.printConfusionMatrix();
	digitStatistics.printOverallSuccessRate();
}

#pragma mark - Digit Collection View Cell Delegate

- (CGFloat)cellSize {
	return (CGFloat)DIGIT_SIZE;
}

#pragma mark - Digit Collection View Cell Data Source

- (UIColor *)pixelColorForDigitCell:(DigitCollectionViewCell *)digitCollectionViewCell Row:(NSUInteger)row col:(NSUInteger)col {
	UIColor *pixelColor;
	
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:digitCollectionViewCell];
	
	Digit digit = mTestingDigitSet.digits[indexPath.row];
	
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

#pragma mark - Digit Training Operation Delegate

- (void)showProgressView {
	[_progressView setAlpha:1.0];
}

- (void)setProgress:(float)progress {
	[_progressView setProgress:progress animated:YES];
}

- (void)didFinishUpdatingProgressView {
	[UIView animateWithDuration:DIGIT_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION animations:^{
		_progressView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[_progressView setProgress:0.0];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
