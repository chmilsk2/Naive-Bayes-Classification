//
//  DigitStatistics.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitStatistics.h"
#include <iomanip>

#define DIGIT_LENGTH 3

DigitStatistics::DigitStatistics() {};

DigitStatistics::~DigitStatistics() {};

#pragma mark - Overall Success Rate 

double DigitStatistics::overallSuccessRate() {
	return mOverallSuccessRate;
}

void DigitStatistics::setOverallSuccessRate(double overallSuccessRate) {
	mOverallSuccessRate = overallSuccessRate;
}

#pragma mark - Success Rates

double DigitStatistics::successRateForClassIndex(int classIndex) {
	double successRate = mSuccessRates[classIndex];
	
	return successRate;
}

void DigitStatistics::setSuccessRateForClassIndex(int classIndex, double successRate) {
	mSuccessRates[classIndex] = successRate;
}

#pragma mark - Confusion Matrix

double DigitStatistics::confusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC) {
	double confusionRate = mConfusionMatrix[classIndexR][classIndexC];
	
	return confusionRate;
}

void DigitStatistics::setConfusionRateForTestImagesFromClassRClassifiedAsClassC(int classIndexR, int classIndexC, double confusionRate) {
	mConfusionMatrix[classIndexR][classIndexC] = confusionRate;
}

#pragma mark - Logging

void DigitStatistics::printSuccessRates() {
	cout << "--- Success Rates ---" << endl;
	cout << endl;
	
	for (int classIndex = 0; classIndex < NUMBER_OF_DIGIT_CLASSES; classIndex++) {
		cout << classIndex << ": " << setprecision(DIGIT_LENGTH) << mSuccessRates[classIndex] << endl;
	}
	
	cout << endl;
}

void DigitStatistics::printConfusionMatrix() {
	cout << "--- Confusion Matrix ---" << endl;
	cout << endl;
	
	for (int i = 0; i < DIGIT_LENGTH; i++) {
		cout << " ";
	}
	
	for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
		cout << classIndexC;
		
		for (int i = 0; i < DIGIT_LENGTH*2; i++) {
			cout << " ";
		}
	}
	
	cout << endl;
	
	for (int classIndexR = 0; classIndexR < NUMBER_OF_DIGIT_CLASSES; classIndexR++) {
		cout << classIndexR << ": ";
		
		for (int classIndexC = 0; classIndexC < NUMBER_OF_DIGIT_CLASSES; classIndexC++) {
			printf("%.2f", mConfusionMatrix[classIndexR][classIndexC]);
			
			for (int i = 0; i < DIGIT_LENGTH; i++) {
				cout << " ";
			}
		}
		
		cout << endl;
	}
	
	cout << endl;
}

void DigitStatistics::printOverallSuccessRate() {
	cout << "--- Overall Success Rate ---" << endl;
	cout << endl;
	
	printf("%.2f\n\n", mOverallSuccessRate);
}






