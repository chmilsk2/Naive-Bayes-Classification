//
//  FaceStatisticsViewController.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceStatisticsViewController.h"
#import "FacePrototypicalInstancesViewController.h"
#import "OddsRatio.h"

#define STATISTICS_CELL_SIZE_MULTIPLIER 2
#define NUMBER_OF_HIGHEST_CONFUSION_PAIRS 1
#define FACE_STATISTICS_NAVIGATION_ITEM_TITLE @"Odds Ratios"
#define PROTOTYPICAL_INSTANCES_BUTTON_TITLE @"Prototypical instances"
#define FaceStatisticsCollectionViewCellIdentifier @"FaceStatisticsCollectionViewCellIdentifier"
#define NUMBER_OF_ODDS_RATIO_TYPES 3

@implementation FaceStatisticsViewController {
	NSArray *_faceImages;
	vector<pair<int, int>> mHighestConfusionPairs;
	TrainingFaceSet mTrainingFaceSet;
	TestingFaceSet mTestingFaceSet;
	FaceStatistics mFaceStatistics;
	vector<OddsRatio> mOddsRatios;
	NSArray *_oddsRatioImages;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_prototypicalInstancesButton;
	ClassificationRule _classificationRule;
	UIColor *_backgroundColor;
}

- (id)initWithTrainingFaceSet:(TrainingFaceSet)trainingFaceSet testingFaceSet:(TestingFaceSet)testingFaceSet faceImages:(NSArray *)faceImages statistics:(FaceStatistics)faceStatistics classificationRule:(ClassificationRule)classificationRule {
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(FACE_WIDTH*STATISTICS_CELL_SIZE_MULTIPLIER, FACE_HEIGHT*STATISTICS_CELL_SIZE_MULTIPLIER);
	
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		_faceImages = faceImages;
		_classificationRule = classificationRule;
		mTrainingFaceSet = trainingFaceSet;
		mTestingFaceSet = testingFaceSet;
		mFaceStatistics = faceStatistics;
		_backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	
	mHighestConfusionPairs = [self highestConfusionPairs];
	mOddsRatios = [self oddRatios];
	_oddsRatioImages = [self oddsRatioImages];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:FACE_STATISTICS_NAVIGATION_ITEM_TITLE];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.prototypicalInstancesButton] animated:YES];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[FaceCollectionViewCell class] forCellWithReuseIdentifier:FaceStatisticsCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_oddsRatioImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FaceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FaceStatisticsCollectionViewCellIdentifier forIndexPath:indexPath];
	
	// set image
	UIImage *digitImage = _oddsRatioImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	return cell;
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

#pragma mark - Prototypical Instances Button

- (UIBarButtonItem *)prototypicalInstancesButton {
	if (!_prototypicalInstancesButton) {
		_prototypicalInstancesButton = [[UIBarButtonItem alloc] initWithTitle:PROTOTYPICAL_INSTANCES_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(prototypicalInstancesButtonTouched)];
	}
	
	return _prototypicalInstancesButton;
}

#pragma mark - Prototypical Instances Button Touched

- (void)prototypicalInstancesButtonTouched {
	FacePrototypicalInstancesViewController *prototypicalInstancesViewController = [[FacePrototypicalInstancesViewController alloc] initWithTestingFaceSet:mTestingFaceSet faceImages:_faceImages classificationRule:_classificationRule];
	[self.navigationController pushViewController:prototypicalInstancesViewController animated:YES];
}

#pragma mark - Highest Confusion Pairs

- (vector<pair<int, int>>)highestConfusionPairs {
	return mFaceStatistics.nHighestConfusionPairs(NUMBER_OF_HIGHEST_CONFUSION_PAIRS);
}

#pragma mark - Odd Ratios

- (vector<OddsRatio>)oddRatios {
	vector<OddsRatio> oddRatios;
	
	for (auto it : mHighestConfusionPairs) {
		OddsRatio oddsRatio;
		
		oddsRatio.setFirstFaceClass(it.first);
		oddsRatio.setSecondFaceClass(it.second);
		
		// first find the minimum and maximum values for each case
		
		double mostNegativeLikelihood1LogValue = DBL_MAX;
		double mostPositiveLikelihood1LogValue = -DBL_MAX;
		
		double mostNegativeLikelihood2LogValue = DBL_MAX;
		double mostPositiveLikelihood2LogValue = -DBL_MAX;
		
		double mostNegativeOddsRatioLogValue = DBL_MAX;
		double mostPositiveOddsRatioLogValue = -DBL_MAX;
		
		for (int row = 0; row < FACE_HEIGHT; row++) {
			for (int col = 0; col < FACE_WIDTH; col++) {
				double likelihood1 = mTrainingFaceSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.firstFaceClass());
				double likelihood1LogValue = log10(likelihood1);
				
				double likelihood2 = mTrainingFaceSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.secondFaceClass());
				double likelihood2LogValue = log10(likelihood2);
				
				double oddsRatioLogValue = likelihood1LogValue - likelihood2LogValue;
				
				if (likelihood1LogValue < mostNegativeLikelihood1LogValue) {
					mostNegativeLikelihood1LogValue = likelihood1LogValue;
				}
				
				if (likelihood1LogValue > mostPositiveLikelihood1LogValue) {
					mostPositiveLikelihood1LogValue = likelihood1LogValue;
				}
				
				if (likelihood2LogValue < mostNegativeLikelihood2LogValue) {
					mostNegativeLikelihood2LogValue = likelihood2LogValue;
				}
				
				if (likelihood2LogValue > mostPositiveLikelihood2LogValue) {
					mostPositiveLikelihood2LogValue = likelihood2LogValue;
				}
				
				if (oddsRatioLogValue < mostNegativeOddsRatioLogValue) {
					mostNegativeOddsRatioLogValue = oddsRatioLogValue;
				}
				
				if (oddsRatioLogValue > mostPositiveOddsRatioLogValue) {
					mostPositiveOddsRatioLogValue = oddsRatioLogValue;
				}
			}
		}
		
		cout << "most negative likelihood 1 log value: " << mostNegativeLikelihood1LogValue << endl;
		cout << "most positive likelihood 1 log value: " << mostPositiveLikelihood1LogValue << endl;
		
		cout << "most negative likelihood 2 log value: " << mostNegativeLikelihood2LogValue << endl;
		cout << "most positive likelihood 2 log value: " << mostPositiveLikelihood2LogValue << endl;
		
		cout << "most negative odds ratio log value: " << mostNegativeOddsRatioLogValue << endl;
		cout << "most positive odds ratio log value: " << mostPositiveOddsRatioLogValue << endl;
		
		for (int row = 0; row < FACE_HEIGHT; row++) {
			for (int col = 0; col < FACE_WIDTH; col++) {
				// first likelihood image
				double likelihood1 = mTrainingFaceSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.firstFaceClass());
				double likelihood1LogValue = log10(likelihood1);
				oddsRatio.setRGBValuesForLogLikelihood(likelihood1LogValue, mostNegativeLikelihood1LogValue, mostPositiveLikelihood1LogValue, row, col, OddsRatioTypeLikelihood1);
				
				// second likelihood image
				double likelihood2 = mTrainingFaceSet.likelihoodForRowColumnAndClassIndex(row, col, oddsRatio.secondFaceClass());
				double likelihood2LogValue = log10(likelihood2);
				oddsRatio.setRGBValuesForLogLikelihood(likelihood2LogValue, mostNegativeLikelihood2LogValue, mostPositiveLikelihood2LogValue, row, col, OddsRatioTypeLikelihood2);
				
				// odds ratio image
				// odds(Fij=1, c1, c2) = P(Fij=1 | c1) / P(Fij=1 | c2)
				double oddsRatioLogValue = likelihood1LogValue - likelihood2LogValue;
				oddsRatio.setRGBValuesForLogLikelihood(oddsRatioLogValue, mostNegativeOddsRatioLogValue, mostPositiveOddsRatioLogValue, row, col, OddsRatioTypeRatio);
			}
		}
		
		oddRatios.push_back(oddsRatio);
	}
	
	return oddRatios;
}

#pragma mark - Face Images for Faces

- (NSArray *)oddsRatioImages {
	NSMutableArray *oddsRatioImages = [NSMutableArray array];
	
	OddsRatioType oddsRatioTypes[NUMBER_OF_ODDS_RATIO_TYPES] = { OddsRatioTypeLikelihood1, OddsRatioTypeLikelihood2, OddsRatioTypeRatio };
	
	for (auto oddsRatio : mOddsRatios) {
		for (auto oddsRatioType : oddsRatioTypes) {
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(FACE_WIDTH, FACE_HEIGHT), YES, 1.0);
			CGContextRef context = UIGraphicsGetCurrentContext();
			
			for (int row = 0; row < FACE_HEIGHT; row++) {
				for (int col = 0; col < FACE_WIDTH; col++) {
					tuple<int, int, int> pixelColor = oddsRatio.RGBValuesForRowColAndOddsRatioType(row, col, oddsRatioType);
					
					UIColor *color = [UIColor colorWithRed:get<0>(pixelColor) green:get<1>(pixelColor) blue:get<2>(pixelColor) alpha:1.0];
					
					CGContextSetFillColorWithColor(context, color.CGColor);
					CGContextFillRect(context, CGRectMake(col, row, 1, 1));
				}
			}
			
			UIImage *oddsRatioImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			[oddsRatioImages addObject:oddsRatioImage];
		}
	}
	
	return [oddsRatioImages copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
