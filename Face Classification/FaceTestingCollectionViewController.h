//
//  FaceTestingCollectionViewController.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingFaceSet.h"
#import "FaceOperationDelegate.h"

@interface FaceTestingCollectionViewController : UICollectionViewController <FaceOperationDelegate>

- (id)initWithTrainingFaceSet:(TrainingFaceSet)trainingFaceSet;

@end
