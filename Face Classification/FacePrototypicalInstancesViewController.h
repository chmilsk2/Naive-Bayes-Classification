//
//  FacePrototypicalInstancesViewController.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestingFaceSet.h"
#import "FaceClassificationRule.h"

@interface FacePrototypicalInstancesViewController : UICollectionViewController

- (id)initWithTestingFaceSet:(TestingFaceSet)testingFaceSet faceImages:(NSArray *)faceImages classificationRule:(ClassificationRule)classificationRule;

@end
