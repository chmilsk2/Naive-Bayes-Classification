//
//  FaceTestingCollectionViewController.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceTestingCollectionViewController.h"
#import "FaceStatisticsViewController.h"
#import "FaceCollectionViewCell.h"
#import "FaceLabelParser.h"
#import "FaceDataParser.h"
#import "Face.h"
#import "ColorRule.h"
#import "ColorMapper.h"
#import "FaceTestingOpreation.h"
#import "FaceClassificationRule.h"
#import "FaceStatistics.h"
#import "QueuePool.h"

#define TEST_NAVIGATION_ITEM_TITLE @"Test"
#define STATISTICS_NAVIGATION_ITEM_TITLE @"Statistics"
#define TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER 2
#define FACE_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION 2.0
#define FACE_TESTING_LABELS_TEXT_NAME @"facedatatestlabels"
#define FACE_TESTING_DATA_TEXT_NAME @"facedatatest"
#define FaceTestingCollectionViewCellIdentifier @"FaceTestingCollectionViewCellIdentifier"

@implementation FaceTestingCollectionViewController {
	TrainingFaceSet mTrainingFaceSet;
	TestingFaceSet mTestingFaceSet;
	FaceStatistics mFaceStatistics;
	ClassificationRule _classificationRule;
	NSArray *_faceImages;
	UIProgressView *_progressView;
	UIBarButtonItem *_testButton;
	UIBarButtonItem *_statisticsButton;
	UIBarButtonItem *_cancelButton;
	UIColor *_backgroundColor;
	UIColor *_correctClassificationTextColor;
	UIColor *_incorrectClassificationTextColor;
}

- (id)initWithTrainingFaceSet:(TrainingFaceSet)trainingFaceSet {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(FACE_WIDTH*TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER, FACE_HEIGHT*TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER);
	
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		_backgroundColor = [UIColor whiteColor];
		
		mTrainingFaceSet = trainingFaceSet;
		
		_correctClassificationTextColor = [UIColor colorWithRed:46.0/255.0 green:139.0/255.0 blue:87.0/255.0 alpha:1.0];
		_incorrectClassificationTextColor = [UIColor colorWithRed:1.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0];
		
		// configure classification rule
		_classificationRule = ClassificationRuleMaximumAPosteriori;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	[self setUpProgressView];
	
	// parse data from files
	pair<vector<int>, vector<vector<char>>> parsedPair = [self parseTestingFiles];
	
	// faceLabels
	vector<int> faceLabels = parsedPair.first;
	
	// faces
	vector<Face> faces = [self facesWithFaceDatas:parsedPair.second	faceLabels:parsedPair.first];
	
	// color map face data
	[self colorMapFaces:faces];
	
	// class frequency map
	map<int, int> frequencyMap = [self frequencyMapWithFaceLabels:faceLabels];
	
	// training face set
	mTestingFaceSet = TestingFaceSet(faceLabels, faces, frequencyMap);
	
	// face images
	_faceImages = [self faceImagesForFaces:faces];
}

#pragma mark - Set Up Navigation

- (void)setUpNavigation {
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.statisticsButton, self.testButton]];
}

#pragma mark - Set Up Collection

- (void)setUpCollection {
	[self.collectionView registerClass:[FaceCollectionViewCell class] forCellWithReuseIdentifier:FaceTestingCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

#pragma mark - Set Up Progress View

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

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_faceImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FaceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FaceTestingCollectionViewCellIdentifier forIndexPath:indexPath];
	
	UIImage *faceImage = _faceImages[indexPath.row];
	[cell.imageView setImage:faceImage];
	
	// set text
	ClassificationType classificationType = mTestingFaceSet.faces()[indexPath.row].classificationType();
	
	if (classificationType != ClassificationTypeNone) {
		[cell.classificationLabel setText:[NSString stringWithFormat:@"%d", mTestingFaceSet.faces()[indexPath.row].faceClass()]];
		
		// set text color
		UIColor *textColor = [UIColor blackColor];
		
		if (classificationType == ClassificationTypeCorrect) {
			textColor = _correctClassificationTextColor;
		}
		
		else if (classificationType == ClassificationTypeIncorrect) {
			textColor = _incorrectClassificationTextColor;
		}
		
		[cell.classificationLabel setTextColor:textColor];
	}
	
	else {
		[cell.classificationLabel setText:@""];
	}
	
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

#pragma mark - Test Button

- (UIBarButtonItem *)testButton {
	if (!_testButton) {
		_testButton = [[UIBarButtonItem alloc] initWithTitle:TEST_NAVIGATION_ITEM_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testButtonTouched)];
	}
	
	return _testButton;
}

#pragma mark - Test Button Touched

- (void)testButtonTouched {
	NSLog(@"Test button touched");
	
	FaceTestingOperation *faceTestingOperation = [[FaceTestingOperation alloc] initWithTestingFaceSet:mTestingFaceSet trainingFaceSet:mTrainingFaceSet classificationRule:_classificationRule];
	[faceTestingOperation setDelegate:self];
	
	faceTestingOperation.faceTestingOperationCompletionBlock = ^(TestingFaceSet testedFaceSet) {
		NSLog(@"finished testing");
		
		mTestingFaceSet = testedFaceSet;
		
		[self didFinishUpdatingProgressView];
		
		[self statistics];
		[self.collectionView reloadData];
	};
	
	[[QueuePool sharedQueuePool].queue addOperation:faceTestingOperation];
}

#pragma mark - Statistics Button

- (UIBarButtonItem *)statisticsButton {
	if (!_statisticsButton) {
		_statisticsButton = [[UIBarButtonItem alloc] initWithTitle:STATISTICS_NAVIGATION_ITEM_TITLE
															 style:UIBarButtonItemStylePlain
															target:self
															action:@selector(statisticsButtonTouched)];
	}
	
	return _statisticsButton;
}

#pragma mark - Statistics Button Touched

- (void)statisticsButtonTouched {
	NSLog(@"Statistics button touched");

	FaceStatisticsViewController *faceStatisticsViewController = [[FaceStatisticsViewController alloc] initWithTrainingFaceSet:mTrainingFaceSet testingFaceSet:mTestingFaceSet faceImages:_faceImages statistics:mFaceStatistics classificationRule:_classificationRule];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:faceStatisticsViewController];
	
	[navController setModalPresentationStyle:UIModalPresentationFormSheet];
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Parse Training Files

- (pair<vector<int>, vector<vector<char>>>)parseTestingFiles {
	// parse face labels
	vector<int> faceLabels = [self parseTestingLabels];
	
	// parse face datas
	vector<vector<char>> faceDatas = [self parseTestingFaceData];
	
	pair<vector<int>, vector<vector<char>>> parsedPair(faceLabels, faceDatas);
	
	return parsedPair;
}

#pragma mark - Parse Testing Labels

- (vector<int>)parseTestingLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:FACE_TESTING_LABELS_TEXT_NAME ofType:@"txt"];
	FaceLabelParser faceLabelParser(filePath.fileSystemRepresentation);
	vector<int> faceLabels = faceLabelParser.parseFaceLabels();
	
	return faceLabels;
}

#pragma mark - Parse Test Face Data

- (vector<vector<char>>)parseTestingFaceData {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:FACE_TESTING_DATA_TEXT_NAME ofType:@"txt"];
	FaceDataParser faceDataParser(filePath.fileSystemRepresentation);
	vector<vector<char>> faceDatas = faceDataParser.parseFaceData();
	
	return faceDatas;
}

#pragma mark - Faces from Data

- (vector<Face>)facesWithFaceDatas:(vector<vector<char>>)faceDatas faceLabels:(vector<int>)faceLabels {
	vector<Face> faces;
	
	int faceIndex = 0;
	
	for (int i = 0; i < faceLabels.size(); i++) {
		Face face(faceDatas[faceIndex], -1);
		
		faces.push_back(face);
		
		faceIndex++;
	}
	
	return faces;
}

#pragma mark - Color Map Faces

- (void)colorMapFaces:(vector<Face> &)faces {
	// color rule
	ColorRule colorRule;
	
	// colored pixels
	ColorMapper colorMapper(colorRule);
	
	for (vector<Face>::iterator it = faces.begin(); it != faces.end(); it++) {
		it->setColorMappedData(colorMapper.colorMappedDataForData(it->faceData().data));
	}
}

#pragma mark - Face Images for Faces

- (NSArray *)faceImagesForFaces:(vector<Face>)faces {
	NSMutableArray *faceImages = [NSMutableArray array];
	
	for (auto it : faces) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(FACE_WIDTH, FACE_HEIGHT), YES, 1.0);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		for (int row = 0; row < FACE_HEIGHT; row++) {
			for (int col = 0; col < FACE_WIDTH; col++) {
				tuple<int, int, int> pixelColor = it.colorForRowCol(row, col);
				
				UIColor *color = [UIColor colorWithRed:get<0>(pixelColor) green:get<1>(pixelColor) blue:get<2>(pixelColor) alpha:1.0];
				
				CGContextSetFillColorWithColor(context, color.CGColor);
				CGContextFillRect(context, CGRectMake(col, row, 1, 1));
			}
		}
		
		UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		[faceImages addObject:faceImage];
	}
	
	return [faceImages copy];
}

#pragma mark - Statistics

- (void)statistics {
	// set success rates, confusion matrix, and overall success rate
	int successCounts[NUMBER_OF_FACE_CLASSES];
	int confusionMatrixCount[NUMBER_OF_FACE_CLASSES][NUMBER_OF_FACE_CLASSES];
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_FACE_CLASSES; classIndexR++) {
		int successCount = 0;
		int confusionCount = 0;
		
		successCounts[classIndexR] = successCount;
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_FACE_CLASSES; classIndexC++) {
			confusionMatrixCount[classIndexR][classIndexC] = confusionCount;
		}
	}
	
	map<int, double> mostPositiveMaximumAPosterioriProbabilityMap;
	map<int, double> mostPositiveMaximumLikelihoodProbabilityMap;
	
	for (int classIndex = 0; classIndex < NUMBER_OF_FACE_CLASSES; classIndex++) {
		mostPositiveMaximumAPosterioriProbabilityMap[classIndex] = -DBL_MAX;
		mostPositiveMaximumLikelihoodProbabilityMap[classIndex] = -DBL_MAX;
	}
	
	int faceIndex = 0;
	
	for (auto it : mTestingFaceSet.faces()) {
		int classifiedFaceClass = it.faceClass();
		int correctFaceClass = mTestingFaceSet.faceLabels()[faceIndex];
		
		// set classification type
		if (classifiedFaceClass == correctFaceClass) {
			mTestingFaceSet.faces()[faceIndex].setClassificationType(ClassificationTypeCorrect);
			successCounts[classifiedFaceClass]++;
		}
		
		else {
			mTestingFaceSet.faces()[faceIndex].setClassificationType(ClassificationTypeIncorrect);
		}
		
		// percentage of images in class r that are classified as class c
		confusionMatrixCount[correctFaceClass][classifiedFaceClass]++;

		// find prototypical instance from each class
		for (int classIndex = 0; classIndex < NUMBER_OF_FACE_CLASSES; classIndex++) {
			cout << "most positive maximum posterior prob" << classIndex << ": " << mostPositiveMaximumAPosterioriProbabilityMap[classIndex] << endl;
			
			if (mTestingFaceSet.faceLabels()[faceIndex] == classIndex && mTestingFaceSet.faces()[faceIndex].faceClass() == classIndex) {
				if (mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex) > mostPositiveMaximumAPosterioriProbabilityMap[classIndex]) {
					mostPositiveMaximumAPosterioriProbabilityMap[classIndex] = mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);;
					mTestingFaceSet.prototypicalMaximumAPosterioriFaceIndexMap()[classIndex] = faceIndex;
				}
				
				if (mTestingFaceSet.faces()[faceIndex].maximumLikelihoodProbabilityForClassIndex(classIndex) > mostPositiveMaximumLikelihoodProbabilityMap[classIndex]) {
					mostPositiveMaximumLikelihoodProbabilityMap[classIndex] = mTestingFaceSet.faces()[faceIndex].maximumLikelihoodProbabilityForClassIndex(classIndex);
					mTestingFaceSet.prototypicalMaximumLikelihoodFaceIndexMap()[classIndex] = faceIndex;
				}
			}
		}
		
		cout << faceIndex << endl;
		
		cout << endl;
		
		mTestingFaceSet.faces()[faceIndex].printMaximumAPosterioriMap();
		
		faceIndex++;
	}
	
	int totalNumberOfInstances = 0;
	int overallSuccessCount = 0;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_FACE_CLASSES; classIndexR++) {
		int totalNumberOfInstancesFromClass = mTestingFaceSet.frequencyMap()[classIndexR];
		
		totalNumberOfInstances += totalNumberOfInstancesFromClass;
		overallSuccessCount += successCounts[classIndexR];
		
		double successRate = (double)successCounts[classIndexR]/(double)totalNumberOfInstancesFromClass;
		
		mFaceStatistics.setSuccessRateForClassIndex(classIndexR, successRate);
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_FACE_CLASSES; classIndexC++) {
			double confusionRate = (double)confusionMatrixCount[classIndexR][classIndexC]/(double)totalNumberOfInstancesFromClass;
			
			mFaceStatistics.setConfusionRateForTestImagesFromClassRClassifiedAsClassC(classIndexR, classIndexC, confusionRate);
		}
	}
	
	double overallSuccessRate = (double)overallSuccessCount/(double)totalNumberOfInstances;
	mFaceStatistics.setOverallSuccessRate(overallSuccessRate);
	
	mFaceStatistics.printSuccessRates();
	mFaceStatistics.printConfusionMatrix();
	mFaceStatistics.printOverallSuccessRate();
	
	mTestingFaceSet.printPrototypicalMaximumAPosterioriFaceIndexMap();
	mTestingFaceSet.printPrototypicalMaximumLikelihoodFaceIndexMap();
}

#pragma mark - Frequency Map with Face Labels

- (map<int, int>)frequencyMapWithFaceLabels:(vector<int>)faceLabels {
	map<int, int> frequencyMap;
	
	for (auto it : faceLabels) {
		int labelValue = (int)it;
		
		if (frequencyMap.count(labelValue) == 0) {
			frequencyMap[labelValue] = 1;
		}
		
		else {
			frequencyMap[labelValue]++;
		}
	}
	
	return frequencyMap;
}

#pragma mark - Face Training Operation Delegate

- (void)showProgressView {
	[_progressView setAlpha:1.0];
}

- (void)setProgress:(float)progress {
	[_progressView setProgress:progress animated:YES];
}

- (void)didFinishUpdatingProgressView {
	[UIView animateWithDuration:FACE_TESTING_PROGRESS_VIEW_FADE_AWAY_DURATION animations:^{
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
