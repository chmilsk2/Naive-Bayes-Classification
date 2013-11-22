//
//  Face.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Face.h"
#include <float.h>

Face::Face() {}

Face::Face(vector<char> data, int faceClass) {
	mFaceData.data = data;
	mFaceClass = faceClass;
	mClassificationType = ClassificationTypeNone;
}

Face::~Face() {}

#pragma mark - Face Data

FaceData Face::faceData() {
	return mFaceData;
}

char Face::pixelValue(int row, int col) {
	int offset = row*FACE_WIDTH + col;
	
	return mFaceData.data[offset];
}

#pragma mark - Face Class

int Face::faceClass() {
	return mFaceClass;
}

void Face::setFaceClass(int faceClass) {
	mFaceClass = faceClass;
}

#pragma mark - Color Map

tuple<int, int, int> Face::colorForRowCol(int row, int col) {
	int offset = row*FACE_WIDTH + col;
	
	return mFaceData.colorMappedData[offset];
}

void Face::setColorMappedData(vector<tuple<int, int, int>> colorMappedData) {
	mFaceData.colorMappedData = colorMappedData;
}

#pragma mark - Face Classification

ClassificationType Face::classificationType() {
	return mClassificationType;
}

void Face::setClassificationType(ClassificationType classificationType) {
	mClassificationType = classificationType;
}

#pragma mark - Maximum A Posteriori

double Face::maximumAPosterioriProbabilityForClassIndex(int classIndex) {
	return mMaximumAPosterioriMap[classIndex];
}

void Face::setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability) {
	mMaximumAPosterioriMap[classIndex] = maximumAPosterioiProbability;
}

#pragma mark - Maximum Likelihood

double Face::maximumLikelihoodProbabilityForClassIndex(int classIndex) {
	return mMaximumLikelihoodMap[classIndex];
}

void Face::setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability) {
	mMaximumLikelihoodMap[classIndex] = maximumLikelihoodProbability;
}

#pragma mark - Logging

void Face::printFace() {
	for (int row = 0; row < FACE_HEIGHT; row++) {
		for (int col = 0; col < FACE_WIDTH; col++) {
			cout << pixelValue(row, col) << " ";
		}
		
		cout << endl;
	}
}

void Face::printMaximumAPosterioriMap() {
	for (map<int, double>::iterator it = mMaximumAPosterioriMap.begin(); it != mMaximumAPosterioriMap.end(); it++) {
		cout << it->first << ": " << it->second << endl;
	}
}

void Face::printMaximumLikelihoodMap() {
	for (map<int, double>::iterator it = mMaximumLikelihoodMap.begin(); it != mMaximumLikelihoodMap.end(); it++) {
		cout << it->first << ": " << it->second;
	}
}

