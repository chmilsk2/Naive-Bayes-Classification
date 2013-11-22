//
//  FaceStatisticsViewController.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingFaceSet.h"
#import "TestingFaceSet.h"
#import "FaceClassificationRule.h"
#import "FaceStatistics.h"
#import "FaceCollectionViewCell.h"

@interface FaceStatisticsViewController : UICollectionViewController

- (id)initWithTrainingFaceSet:(TrainingFaceSet)trainingFaceSet testingFaceSet:(TestingFaceSet)testingFaceSet faceImages:(NSArray *)faceImages statistics:(FaceStatistics)faceStatistics classificationRule:(ClassificationRule)classificationRule;

@end
