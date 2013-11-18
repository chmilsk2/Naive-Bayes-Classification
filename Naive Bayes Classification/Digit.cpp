//
//  Digit.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Digit.h"
#include <math.h>

using namespace std;

Digit::Digit() {
	// -1 means the digit class has not yet been classified
	mDigitClass = -1;
	mClassificationType = ClassificationTypeNone;
}

Digit::~Digit() {}

#pragma mark - Digit Class

int Digit::digitClass() {
	return mDigitClass;
}

void Digit::setDigitClass(int digitClass) {
	mDigitClass = digitClass;
}

#pragma mark - Pixel Values

char Digit::pixelValue(int row, int col) {
	char pixelChar = mPixels[row][col];
	return pixelChar;
}

void Digit::setPixelValue(int row, int col, char value) {
	mPixels[row][col] = value;
}

#pragma mark - Digit Classification

ClassificationType Digit::classificationType() {
	return mClassificationType;
}

void Digit::setClassificationType(ClassificationType classificationType) {
	mClassificationType = classificationType;
}

#pragma mark - Maximum A Posteriori

double Digit::maximumAPosterioriProbabilityForClassIndex(int classIndex) {
	return mMaximumAPosterioriMap[classIndex];
}

void Digit::setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability) {
	mMaximumAPosterioriMap[classIndex] = maximumAPosterioiProbability;
}

#pragma mark - Maximum Likelihood

double Digit::maximumLikelihoodProbabilityForClassIndex(int classIndex) {
	return mMaximumLikelihoodMap[classIndex];
}

void Digit::setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability) {
	mMaximumLikelihoodMap[classIndex] = maximumLikelihoodProbability;
}

#pragma mark - Logging

void Digit::printDigit() {
	for (int row = 0; row < DIGIT_SIZE; row++) {
		for (int col = 0; col < DIGIT_SIZE; col++) {
			cout << pixelValue(row, col) << " ";
		}
		
		cout << endl;
	}
}

void Digit::printMaximumAPosterioriMap() {
	for (map<int, double>::iterator it = mMaximumAPosterioriMap.begin(); it != mMaximumAPosterioriMap.end(); it++) {
		cout << it->first << ": " << it->second << endl;
	}
}

void Digit::printMaximumLikelihoodMap() {
	for (map<int, double>::iterator it = mMaximumLikelihoodMap.begin(); it != mMaximumLikelihoodMap.end(); it++) {
		cout << it->first << ": " << it->second;
	}
}
