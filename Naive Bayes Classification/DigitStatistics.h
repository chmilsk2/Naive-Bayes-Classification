//
//  DigitStatistics.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__DigitStatistics__
#define __Naive_Bayes_Classification__DigitStatistics__

#include <iostream>

using namespace std;

class DigitStatistics {
	double mOverallSuccessRate;
	double mSuccessRates[NUMBER_OF_DIGIT_CLASSES];
	
	// percentage of test images from class r that are classified as class c where r = row, c = col
	double mConfusionMatrix[NUMBER_OF_DIGIT_CLASSES][NUMBER_OF_DIGIT_CLASSES];
	
	public:
		DigitStatistics();
		~DigitStatistics();
		double overallSuccessRate();
		void setOverallSuccessRate(double overallSuccessRate);
		double successRateForClassIndex(int classIndex);
		void setSuccessRateForClassIndex(int classIndex, double successRate);
		double confusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC);
		void setConfusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC, double confusionRate);
	
		// logging
		void printOverallSuccessRate();
		void printSuccessRates();
		void printConfusionMatrix();
};

#endif /* defined(__Naive_Bayes_Classification__DigitStatistics__) */
