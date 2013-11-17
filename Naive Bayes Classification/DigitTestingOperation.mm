//
//  DigitTestingOperation.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingOperation.h"
#import <vector>
#import <math.h>

@implementation DigitTestingOperation {
	DigitSet mTrainingDigitSet;
	DigitSet mTestDigitSet;
}

- (void)main {
	[self test];
	
	[self didFinishTesting];
}

- (id)initWithTestDigitSet:(DigitSet)testDigitSet trainingDigitSet:(DigitSet)trainingDigitSet {
	self = [super init];
	
	if (self) {
		mTrainingDigitSet = trainingDigitSet;
		mTestDigitSet = testDigitSet;
	}
	
	return self;
}

- (void)test {
	NSLog(@"testing");
	
	// in order to avoid underflow, work with logs instead
	for (int digitIndex = 0; digitIndex < mTestDigitSet.digits.size(); digitIndex++) {
		for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
			double priorProbability = mTrainingDigitSet.priorProbabilityMap[classIndex];
			double logOfPriorProbability = log10(priorProbability);
			
			// MAP
			mTestDigitSet.maximumAPosterioriMap[classIndex] = 0;
			mTestDigitSet.maximumAPosterioriMap[classIndex] += logOfPriorProbability;
			
			// ML (omit prior probability)
			mTestDigitSet.maximumLikelihoodMap[classIndex] = 0;
			
			for (int row = 0; row < DIGIT_SIZE; row++) {
				for (int col = 0; col < DIGIT_SIZE; col++) {
					double likelihood = mTrainingDigitSet.likelihoodForRowColumnAndClassIndex(row, col, classIndex);
					
					char pixelValue = mTestDigitSet.digits[digitIndex].pixelValue(row, col);
					
					if (pixelValue == ' ') {
						likelihood = (double)(1 - likelihood);
					}
					
					double logOfLikelihood = log10(likelihood);
					
					mTestDigitSet.maximumAPosterioriMap[classIndex] += logOfLikelihood;
					mTestDigitSet.maximumLikelihoodMap[classIndex] += logOfLikelihood;
				}
			}
		}
		
		// classify the digits based on the most positive probability value
		double mostPositiveMaximumAPosterioriProbability = -DBL_MAX;
		double mostPositiveMaximumLikelihoodProbability = -DBL_MAX;
		
		int maximumAPosterioriDigitClass = -1;
		int maximumLikelihoodDigitClass = -1;
		
		for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
			double maximumAPosterioriProbability = mTestDigitSet.maximumAPosterioriMap[classIndex];
			double maximumLikelihoodProbability = mTestDigitSet.maximumLikelihoodMap[classIndex];
			
			if (maximumAPosterioriProbability > mostPositiveMaximumAPosterioriProbability) {
				mostPositiveMaximumAPosterioriProbability = maximumAPosterioriProbability;
				maximumAPosterioriDigitClass = classIndex;
			}
			
			if (maximumLikelihoodProbability > mostPositiveMaximumLikelihoodProbability) {
				mostPositiveMaximumLikelihoodProbability = maximumLikelihoodProbability;
				maximumLikelihoodDigitClass = classIndex;
			}
			
			mTestDigitSet.digits[digitIndex].setDigitClass(maximumAPosterioriDigitClass);
		}
	}
}

- (void)didFinishTesting {
	if (self.digitTestingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.digitTestingOperationCompletionBlock(mTestDigitSet);
		});
	}
}

@end
