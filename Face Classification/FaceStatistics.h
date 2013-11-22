//
//  FaceStatistics.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__FaceStatistics__
#define __Face_Classification__FaceStatistics__

#include <iostream>
#include <vector>

using namespace std;

class FaceStatistics {
	double mOverallSuccessRate;
	double mSuccessRates[NUMBER_OF_FACE_CLASSES];
	
	// percentage of test images from class r that are classified as class c where r = row, c = col
	double mConfusionMatrix[NUMBER_OF_FACE_CLASSES][NUMBER_OF_FACE_CLASSES];
	
public:
	FaceStatistics();
	~FaceStatistics();
	
	// overall success rate
	double overallSuccessRate();
	void setOverallSuccessRate(double overallSuccessRate);
	
	// success rate
	double successRateForClassIndex(int classIndex);
	void setSuccessRateForClassIndex(int classIndex, double successRate);
	
	// confusion rate
	double confusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC);
	void setConfusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC, double confusionRate);
	vector<pair<int, int>> nHighestConfusionPairs(int n);
	
	// logging
	void printOverallSuccessRate();
	void printSuccessRates();
	void printConfusionMatrix();
};

#endif /* defined(__Face_Classification__FaceStatistics__) */
