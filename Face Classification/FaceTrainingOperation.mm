//
//  FaceTrainingOperation.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceTrainingOperation.h"

#define SMOOTHING_CONSTANT 1
#define NUMBER_OF_POSSIBLE_VALUES_PER_FEATURE 2

@implementation FaceTrainingOperation {
	TrainingFaceSet mTrainingFaceSet;
}

- (void)main {
	[self train];
	
	[self didFinishTraining];
}

- (id)initWithFaceSet:(TrainingFaceSet)trainingFaceSet {
	self = [super init];
	
	if (self) {
		mTrainingFaceSet = trainingFaceSet;
	}
	
	return self;
}

- (void)train {
	cout << "training" << endl;
	
	if ([self.delegate respondsToSelector:@selector(showProgressView)]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate showProgressView];
		});
	}
	
	unsigned long totalNumberOfFaces = mTrainingFaceSet.faces().size();
	
	int faceIndex = 0;
	
	int progressFactor = 2;
	
	// populate pixel frequency maps
	for (auto &it : mTrainingFaceSet.faces()) {
		Face face = it;
		int classIndex = face.faceClass();
		
		for (int row = 0; row < FACE_HEIGHT; row++) {
			for (int col = 0; col < FACE_WIDTH; col++) {
				mTrainingFaceSet.updatePixelFrequencyMapUsingRowAndColumnForClassIndex(row, col, face, classIndex);
			}
		}
		
		faceIndex++;
		
		float progress = (float)faceIndex/(float)totalNumberOfFaces;
		progress = progress/(float)progressFactor;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
	
	// compute likelihoods P(F_ij|class)
	for (int classIndex = 0; classIndex < NUMBER_OF_FACE_CLASSES; classIndex++) {
		for (int row = 0; row < FACE_HEIGHT; row++) {
			for (int col = 0; col < FACE_WIDTH; col++) {
				int pixelFrequency = mTrainingFaceSet.pixelFrequencyForRowColumnAndClassIndex(row, col, classIndex);
				int totalNumberOfTrainingExamplesInClass = mTrainingFaceSet.frequencyForClassIndex(classIndex);
				
				// likelihood = P(Fij = f | class) = (# of times pixel (i,j) has value f in training examples from this class) / (Total # of training examples from this class)
				double likelihood = [self likelihoodWithSmoothingForPixelFrequency:pixelFrequency
											  totalNumberOfTrainingExamplesInClass:totalNumberOfTrainingExamplesInClass];
				
				mTrainingFaceSet.updateLikelihoodMapUsingRowAndColumnForClassIndex(row, col, classIndex, likelihood);
			}
		}
		
		// compute prior probabilities P(class) = (# of examples in training set from this class)/(total # of examples in training set)
		mTrainingFaceSet.updatePriorProbabilityForClassIndex(classIndex);
		
		float progress = (float)(classIndex + 1)/(float)NUMBER_OF_FACE_CLASSES;
		progress = (float)progressFactor + progress/(float)progressFactor;
		
		if ([self.delegate respondsToSelector:@selector(setProgress:)]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate setProgress:progress];
			});
		}
	}
}

#pragma mark - Likelihood without Smoothing

- (double)likelihoodWithoutSmoothingForPixelFrequency:(int)pixelFrequency totalNumberOfTrainingExamplesInClass:(int)totalNumberOfTrainingExamplesInClass {
	double likelihood = (double)pixelFrequency/(double)totalNumberOfTrainingExamplesInClass;
	
	return likelihood;
}

#pragma mark - Likelihood with Smoothing

- (double)likelihoodWithSmoothingForPixelFrequency:(int)pixelFrequency totalNumberOfTrainingExamplesInClass:(int)totalNumberOfTrainingExamplesInClass {
	// smoothing constant, the higher the value of k, the stronger the smoothing (experiment with values from 1 to 50)
	int k = SMOOTHING_CONSTANT;
	
	// v is the number of possible values the feature can take on (in this case the pixel feature can be filled or not filled)
	int v = NUMBER_OF_POSSIBLE_VALUES_PER_FEATURE;
	
	double likelihood = (double)(pixelFrequency + k)/(double)(totalNumberOfTrainingExamplesInClass + k*v);
	
	return likelihood;
}

- (void)didFinishTraining {
	if (self.faceTrainingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.faceTrainingOperationCompletionBlock(mTrainingFaceSet);
		});
	}
}

@end
