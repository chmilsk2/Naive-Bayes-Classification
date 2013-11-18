//
//  Digit.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__Digit__
#define __Naive_Bayes_Classification__Digit__

#include <iostream>
#include <map>

#define DIGIT_SIZE 28

using namespace std;

enum ClassificationType {
	ClassificationTypeNone,
	ClassificationTypeCorrect,
	ClassificationTypeIncorrect
};

class Digit {
	int mDigitClass;
	char mPixels[DIGIT_SIZE][DIGIT_SIZE];
	map<int, double> mMaximumAPosterioriMap;
	map<int, double> mMaximumLikelihoodMap;
	ClassificationType mClassificationType;
	
	public:
		Digit();
		~Digit();
	
		// digit class
		int digitClass();
		void setDigitClass(int digitClass);
	
		// pixel value
		char pixelValue(int row, int col);
		void setPixelValue(int row, int col, char value);
	
		// classification type
		ClassificationType classificationType();
		void setClassificationType(ClassificationType classificationType);
	
		// MAP classification
		double maximumAPosterioriProbabilityForClassIndex(int classIndex);
		void setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability);
	
		// ML classification
		double maximumLikelihoodProbabilityForClassIndex(int classIndex);
		void setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability);
	
		// logging
		void printDigit();
		void printMaximumAPosterioriMap();
		void printMaximumLikelihoodMap();
};

#endif /* defined(__Naive_Bayes_Classification__Digit__) */
