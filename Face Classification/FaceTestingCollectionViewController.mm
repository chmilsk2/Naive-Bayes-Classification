//
//  FaceTestingCollectionViewController.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceTestingCollectionViewController.h"
#import "FaceCollectionViewCell.h"
#import "FaceLabelParser.h"
#import "FaceDataParser.h"
#import "Face.h"
#import "ColorRule.h"
#import "ColorMapper.h"

#define TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER 2
#define FACE_TESTING_LABELS_TEXT_NAME @"facedatatestlabels"
#define FACE_TESTING_DATA_TEXT_NAME @"facedatatest"
#define FaceTestingCollectionViewCellIdentifier @"FaceTestingCollectionViewCellIdentifier"

@implementation FaceTestingCollectionViewController {
	NSArray *_faceImages;
	UIBarButtonItem *_cancelButton;
	UIColor *_backgroundColor;
}

- (id)init {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(FACE_WIDTH*TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER, FACE_HEIGHT*TESTING_FACE_COLLECTION_VIEW_SIZE_MULTIPLIER);
	
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
	pair<vector<bool>, vector<vector<char>>> parsedPair = [self parseTestingFiles];
	
	// faces
	vector<Face> faces = [self facesWithFaceDatas:parsedPair.second	faceLabels:parsedPair.first];
	
	// color map face data
	[self colorMapFaces:faces];
	
	// face images
	_faceImages = [self faceImagesForFaces:faces];
}

#pragma mark - Set Up Navigation

- (void)setUpNavigation {
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
}

#pragma mark - Set Up Collection

- (void)setUpCollection {
	[self.collectionView registerClass:[FaceCollectionViewCell class] forCellWithReuseIdentifier:FaceTestingCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_faceImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FaceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FaceTestingCollectionViewCellIdentifier forIndexPath:indexPath];
	
	UIImage *faceImage = _faceImages[indexPath.row];
	[cell.imageView setImage:faceImage];
	
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

#pragma mark - Parse Training Files

- (pair<vector<bool>, vector<vector<char>>>)parseTestingFiles {
	// parse face labels
	vector<bool> faceLabels = [self parseTestingLabels];
	
	// parse face datas
	vector<vector<char>> faceDatas = [self parseTestingFaceData];
	
	pair<vector<bool>, vector<vector<char>>> parsedPair(faceLabels, faceDatas);
	
	return parsedPair;
}

#pragma mark - Parse Testing Labels

- (vector<bool>)parseTestingLabels {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:FACE_TESTING_LABELS_TEXT_NAME ofType:@"txt"];
	FaceLabelParser faceLabelParser(filePath.fileSystemRepresentation);
	vector<bool> faceLabels = faceLabelParser.parseFaceLabels();
	
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
