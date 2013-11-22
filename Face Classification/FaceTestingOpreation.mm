//
//  FaceTestingOpreation.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceTestingOpreation.h"
#import <vector>
#import <math.h>

@implementation FaceTestingOperation {
	TrainingFaceSet mTrainingFaceSet;
	TestingFaceSet mTestingFaceSet;
	ClassificationRule _classificationRule;
}

- (void)main {
	[self test];
	
	[self didFinishTesting];
}

- (id)initWithTestingFaceSet:(TestingFaceSet)testingFaceSet trainingFaceSet:(TrainingFaceSet)trainingFaceSet classificationRule:(ClassificationRule)classificationRule {
	self = [super init];
	
	if (self) {
		mTrainingFaceSet = trainingFaceSet;
		mTestingFaceSet = testingFaceSet;
		_classificationRule = classificationRule;
	}
	
	return self;
}

- (void)test {
	NSLog(@"testing");
	
	if ([self.delegate respondsToSelector:@selector(showProgressView)]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate showProgressView];
		});
	}
	
	unsigned long totalNumberOfFaces = mTestingFaceSet.faces().size();
	
	// in order to avoid underflow, work with logs instead
	for (int faceIndex = 0; faceIndex < mTestingFaceSet.faces().size(); faceIndex++) {
		for (int classIndex = 0; classIndex < NUMBER_OF_FACE_CLASSES; classIndex++) {
			double priorProbability = mTrainingFaceSet.priorProbabilityMap()[classIndex];
			double logOfPriorProbability = log10(priorProbability);
			
			// MAP
			double maximumAPosterioriProbability = 0;
			mTestingFaceSet.faces()[faceIndex].setMaximumAPosterioriProbabilityForClassIndex(classIndex, maximumAPosterioriProbability);
			maximumAPosterioriProbability = mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex) + logOfPriorProbability;
			mTestingFaceSet.faces()[faceIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumAPosterioriProbability);
			
			// ML (omit prior probability)
			double maximumLikelihoodProbability = 0;
			mTestingFaceSet.faces()[faceIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumLikelihoodProbability);
			
			for (int row = 0; row < FACE_HEIGHT; row++) {
				for (int col = 0; col < FACE_WIDTH; col++) {
					double likelihood = mTrainingFaceSet.likelihoodForRowColumnAndClassIndex(row, col, classIndex);
					
					char pixelValue = mTestingFaceSet.faces()[faceIndex].pixelValue(row, col);
					
					if (pixelValue == ' ') {
						likelihood = (double)(1 - likelihood);
					}
					
					double logOfLikelihood = log10(likelihood);
					
					maximumAPosterioriProbability = mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
					maximumLikelihoodProbability = mTestingFaceSet.faces()[faceIndex].maximumLikelihoodProbabilityForClassIndex(classIndex);
					
					mTestingFaceSet.faces()[faceIndex].setMaximumAPosterioriProbabilityForClassIndex(classIndex, maximumAPosterioriProbability + logOfLikelihood);
					mTestingFaceSet.faces()[faceIndex].setMaximumLikelihoodProbabilityForClassIndex(classIndex, maximumLikelihoodProbability + logOfLikelihood);
				}
			}
		}
		
		// classify the digits based on the most positive probability value
		double mostPositiveMaximumAPosterioriProbability = -DBL_MAX;
		double mostPositiveMaximumLikelihoodProbability = -DBL_MAX;
		
		int faceClass = -1;
		
		for (int classIndex = 0; classIndex < NUMBER_OF_FACE_CLASSES; classIndex++) {
			double maximumAPosterioriProbability = mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
			double maximumLikelihoodProbability = mTestingFaceSet.faces()[faceIndex].maximumAPosterioriProbabilityForClassIndex(classIndex);
			
			if (_classificationRule == ClassificationRuleMaximumAPosteriori) {
				if (maximumAPosterioriProbability > mostPositiveMaximumAPosterioriProbability) {
					mostPositiveMaximumAPosterioriProbability = maximumAPosterioriProbability;
					faceClass = classIndex;
				}
			}
			
			else if (_classificationRule == ClassificationRuleMaximumLikelihood) {
				if (maximumLikelihoodProbability > mostPositiveMaximumLikelihoodProbability) {
					mostPositiveMaximumLikelihoodProbability = maximumLikelihoodProbability;
					faceClass = classIndex;
				}
			}
			
			mTestingFaceSet.faces()[faceIndex].setFaceClass(faceClass);
		}
		
		float progress = (float)faceIndex/(float)totalNumberOfFaces;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
}

- (void)didFinishTesting {
	if (self.faceTestingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.faceTestingOperationCompletionBlock(mTestingFaceSet);
		});
	}
}

@end
