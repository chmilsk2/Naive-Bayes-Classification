//
//  FaceTrainingCollectionViewController.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceTrainingCollectionViewController.h"
#import "FaceTestingCollectionViewController.h"
#import "FaceLabelParser.h"
#import "FaceDataParser.h"
#import "Face.h"
#import "ColorRule.h"
#import "ColorMapper.h"
#import "TrainingFaceSet.h"

#define TRAINING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER 2
#define TRAIN_NAVIGATION_ITEM_TITLE @"Train"
#define TEST_SET_NAVIGATION_ITEM_TITLE @"Test set"
#define FACE_TRAINING_LABELS_TEXT_NAME @"facedatatrainlabels"
#define FACE_TRAINING_DATA_TEXT_NAME @"facedatatrain"
#define FaceTrainingCollectionViewCellIdentifier @"FaceTrainingCollectionViewCellIdentifier"

@implementation FaceTrainingCollectionViewController {
	TrainingFaceSet mTrainingFaceSet;
	NSArray *_faceImages;
	UIBarButtonItem *_trainButton;
	UIBarButtonItem *_testSetButton;
	UIColor *_backgroundColor;
}

- (id)init {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(FACE_WIDTH*TRAINING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER, FACE_HEIGHT*TRAINING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER);
	
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		_backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	
	// parse data from files
	pair<vector<bool>, vector<vector<char>>> parsedPair = [self parseTrainingFiles];
	
	// faceLabels
	vector<bool> faceLabels = parsedPair.first;
	
	// faces
	vector<Face> faces = [self facesWithFaceDatas:parsedPair.second	faceLabels:parsedPair.first];
	
	// color map face data
	[self colorMapFaces:faces];
	
	// training face set
	mTrainingFaceSet = TrainingFaceSet(faceLabels, faces);
	
	// face images
	_faceImages = [self faceImagesForFaces:faces];
}

#pragma mark - Set Up Navigation

- (void)setUpNavigation {
	[self.navigationItem setRightBarButtonItems:@[self.testSetButton, self.trainButton]];
}

#pragma mark - Set Up Collection

- (void)setUpCollection {
	[self.collectionView registerClass:[FaceCollectionViewCell class] forCellWithReuseIdentifier:FaceTrainingCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_faceImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FaceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FaceTrainingCollectionViewCellIdentifier forIndexPath:indexPath];
	
	UIImage *faceImage = _faceImages[indexPath.row];
	[cell.imageView setImage:faceImage];
	
	return cell;
}

#pragma mark - Train Button

- (UIBarButtonItem *)trainButton {
	if (!_trainButton) {
		_trainButton = [[UIBarButtonItem alloc] initWithTitle:TRAIN_NAVIGATION_ITEM_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(trainButtonTouched)];
	}
	
	return _trainButton;
}

#pragma mark - Train Button Touched

- (void)trainButtonTouched {
	NSLog(@"Train button touched");
}

#pragma mark - Test Set Button

- (UIBarButtonItem *)testSetButton {
	if (!_testSetButton) {
		_testSetButton = [[UIBarButtonItem alloc] initWithTitle:TEST_SET_NAVIGATION_ITEM_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(testSetButtonTouched)];
	}
	
	return _testSetButton;
}

#pragma mark - Test Button Touched

- (void)testSetButtonTouched {
	NSLog(@"Test set button touched");
	
	FaceTestingCollectionViewController *faceTestingCollectionViewController = [[FaceTestingCollectionViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:faceTestingCollectionViewController];
	
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Parse Training Files

- (pair<vector<bool>, vector<vector<char>>>)parseTrainingFiles {
	// parse face labels
	vector<bool> faceLabels = [self parseTrainingLabels];
	
	// parse face datas
	vector<vector<char>> faceDatas = [self parseTrainingFaceData];
	
	pair<vector<bool>, vector<vector<char>>> parsedPair(faceLabels, faceDatas);
	
	return parsedPair;
}

#pragma mark - Parse Training Labels

- (vector<bool>)parseTrainingLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:FACE_TRAINING_LABELS_TEXT_NAME ofType:@"txt"];
	FaceLabelParser faceLabelParser(filePath.fileSystemRepresentation);
	vector<bool> faceLabels = faceLabelParser.parseFaceLabels();
	
	return faceLabels;
}

#pragma mark - Parse Training Face Data

- (vector<vector<char>>)parseTrainingFaceData {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:FACE_TRAINING_DATA_TEXT_NAME ofType:@"txt"];
	FaceDataParser faceDataParser(filePath.fileSystemRepresentation);
	vector<vector<char>> faceDatas = faceDataParser.parseFaceData();
	
	return faceDatas;
}

#pragma mark - Faces from Data

- (vector<Face>)facesWithFaceDatas:(vector<vector<char>>)faceDatas faceLabels:(vector<bool>)faceLabels {
	vector<Face> faces;
	
	int faceIndex = 0;
	
	for (auto it : faceLabels) {
		Face face(faceDatas[faceIndex], it);
		
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
