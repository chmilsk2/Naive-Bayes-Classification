//
//  FaceTestingOpreation.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceOperationDelegate.h"
#import "TrainingFaceSet.h"
#import "TestingFaceSet.h"
#import "FaceClassificationRule.h"

typedef void(^FaceTestingOperationHandler)(TestingFaceSet testedFaceSet);

@interface FaceTestingOperation : NSOperation

@property (copy) FaceTestingOperationHandler faceTestingOperationCompletionBlock;
@property (nonatomic, weak) id <FaceOperationDelegate> delegate;

- (id)initWithTestingFaceSet:(TestingFaceSet)testingFaceSet trainingFaceSet:(TrainingFaceSet)trainingFaceSet classificationRule:(ClassificationRule)classificationRule;

@end

