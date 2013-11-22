//
//  FaceTrainingOperation.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceOperationDelegate.h"
#import "TrainingFaceSet.h"

typedef void(^FaceTrainingOperationHandler)(TrainingFaceSet trainingFaceSet);

@interface FaceTrainingOperation : NSOperation

@property (copy) FaceTrainingOperationHandler faceTrainingOperationCompletionBlock;
@property (nonatomic, weak) id <FaceOperationDelegate> delegate;

- (id)initWithFaceSet:(TrainingFaceSet)trainingFaceSet;

@end