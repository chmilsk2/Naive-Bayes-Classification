//
//  FacePrototypicalInstancesViewController.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FacePrototypicalInstancesViewController.h"
#import "FaceClassificationRule.h"
#import "FaceCollectionViewCell.h"

#define FACE_PROTOTYPICAL_NAVIGATION_ITEM_TITLE @"Prototypical Instances"
#define PROTOTYPICAL_CELL_SIZE_MULTIPLIER 2
#define FacePrototypicalInstancesCollectionViewCellIdentifier @"FacePrototypicalInstancesCollectionViewCellIdentifier"

@implementation FacePrototypicalInstancesViewController {
	NSArray *_faceImages;
	UIBarButtonItem *_cancelButton;
	NSArray *_prototypicalImages;
	NSMutableArray *_prototypicalFaceIndices;
	ClassificationRule _classificationRule;
	UIColor *_backgroundColor;
	TestingFaceSet mFaceTestingSet;
}

- (id)initWithTestingFaceSet:(TestingFaceSet)testingFaceSet faceImages:(NSArray *)faceImages classificationRule:(ClassificationRule)classificationRule {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(FACE_WIDTH*PROTOTYPICAL_CELL_SIZE_MULTIPLIER, FACE_HEIGHT*PROTOTYPICAL_CELL_SIZE_MULTIPLIER);
	
	self = [super initWithCollectionViewLayout:flowLayout];
	
	if (self) {
		_faceImages = faceImages;
		_prototypicalFaceIndices = [NSMutableArray array];
		_classificationRule = classificationRule;
		_backgroundColor = [UIColor whiteColor];
		mFaceTestingSet = testingFaceSet;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self setUpCollection];
	_prototypicalImages = [self prototypicalImages];
}

- (void)setUpNavigation {
	[self.navigationItem setTitle:FACE_PROTOTYPICAL_NAVIGATION_ITEM_TITLE];
}

- (void)setUpCollection {
	[self.collectionView registerClass:[FaceCollectionViewCell class] forCellWithReuseIdentifier:FacePrototypicalInstancesCollectionViewCellIdentifier];
	[self.collectionView setBackgroundColor:_backgroundColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_prototypicalImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FaceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FacePrototypicalInstancesCollectionViewCellIdentifier forIndexPath:indexPath];
	
	// set image
	UIImage *digitImage = _prototypicalImages[indexPath.row];
	[cell.imageView setImage:digitImage];
	
	int prototypicalFaceIndex = ((NSNumber *)_prototypicalFaceIndices[indexPath.row]).intValue;
	
	// set text
	[cell.classificationLabel setText:[NSString stringWithFormat:@"%d", mFaceTestingSet.faces()[prototypicalFaceIndex].faceClass()]];
	
	return cell;
}

#pragma mark - Prototypical Images

- (NSArray *)prototypicalImages {
	NSMutableArray *images = [NSMutableArray array];
	
	if (_classificationRule == ClassificationRuleMaximumAPosteriori) {
		for (auto it : mFaceTestingSet.prototypicalMaximumAPosterioriFaceIndexMap()) {

			[_prototypicalFaceIndices addObject:[NSNumber numberWithInt:it.second]];
		}
	}
	
	else if (_classificationRule == ClassificationRuleMaximumLikelihood) {
		for (auto it : mFaceTestingSet.prototypicalMaximumLikelihoodFaceIndexMap()) {
			[_prototypicalFaceIndices addObject:[NSNumber numberWithInt:it.second]];
		}
	}
	
	for (NSNumber *prototypicalFaceIndex in _prototypicalFaceIndices) {
		UIImage *image = _faceImages[prototypicalFaceIndex.integerValue];
		
		[images addObject:image];
	}
	
	return [images copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end