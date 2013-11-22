//
//  TrainingFaceSet.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "TrainingFaceSet.h"
#include <math.h>

TrainingFaceSet::TrainingFaceSet() {}

TrainingFaceSet::TrainingFaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap):FaceSet(faceLabels, faces, frequencyMap) {
	mBitShiftSize = bitShiftSizeUsingFaceSize(FACE_WIDTH, FACE_HEIGHT);
}

TrainingFaceSet::~TrainingFaceSet() {}

#pragma mark - Pixel Frequency

map<int, int> & TrainingFaceSet::pixelFrequencyMapForClassIndex(int classIndex) {
	return mPixelFrequencyMaps[classIndex];
}

void TrainingFaceSet::updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, Face & face, int classIndex) {
	char pixelValue = face.pixelValue(row, col);
	
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	if (mPixelFrequencyMaps[classIndex].find(pixelIndex) == mPixelFrequencyMaps[classIndex].end()) {
		mPixelFrequencyMaps[classIndex][pixelIndex] = 0;
	}
	
	if (pixelValue == '#') {
		mPixelFrequencyMaps[classIndex][pixelIndex]++;
	}
}

int TrainingFaceSet::pixelFrequencyForRowColumnAndClassIndex(int row, int col, int classIndex) {
	int pixelFrequency = 0;
	
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	pixelFrequency = mPixelFrequencyMaps[classIndex][pixelIndex];
	
	return pixelFrequency;
}

#pragma mark - Prior Probabilities

map<int, double> & TrainingFaceSet::priorProbabilityMap() {
	return mPriorProbabilityMap;
}

void TrainingFaceSet::updatePriorProbabilityForClassIndex(int classIndex) {
	int numberOfExamplesInTrainingSetForClass = frequencyMap()[classIndex];
	unsigned long totalNumberOfExamplesInTrainingSet = faces().size();
	
	double priorProbability = (double)numberOfExamplesInTrainingSetForClass/(double)totalNumberOfExamplesInTrainingSet;
	mPriorProbabilityMap[classIndex] = priorProbability;
}

#pragma mark - Likelihood Probabilities

void TrainingFaceSet::updateLikelihoodMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex, double likelihood) {
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	if (mLikelihoodMaps[classIndex].find(pixelIndex) == mLikelihoodMaps[classIndex].end()) {
		mLikelihoodMaps[classIndex][pixelIndex] = 0;
	}
	
	mLikelihoodMaps[classIndex][pixelIndex] = likelihood;
}

double TrainingFaceSet::likelihoodForRowColumnAndClassIndex(int row, int col, int classIndex) {
	int pixelIndex = pixelIndexForRowAndColumn(row, col);
	
	double likelihood = mLikelihoodMaps[classIndex][pixelIndex];
	
	return likelihood;
}

#pragma mark - Pixel Index

int TrainingFaceSet::pixelIndexForRowAndColumn(int row, int col) {
	int pixelIndex = (row << mBitShiftSize) + col;
	
	return pixelIndex;
}

// bit shift sie

int TrainingFaceSet::bitShiftSizeUsingFaceSize(int width, int height) {
	// compute the number of bits necessary to represent the larger of the two dimensions
	int largerDimension = height;
	
	if (width > height) {
		largerDimension = width;
	}
	
	int bitShiftSize = 0;
	
	if (largerDimension != 0) {
		int exponent = 0;
		int divisor = pow(2, exponent);
		bool shouldContinue = true;
		
		while (shouldContinue) {
			if (largerDimension/divisor >= 1) {
				exponent++;
				divisor = pow(2, exponent);
			}
			
			else {
				shouldContinue = false;
				bitShiftSize = exponent;
			}
		}
	}
	
	return bitShiftSize;
}

void TrainingFaceSet::printPixelFrequencyMaps() {
	for (map<int, map<int, int>>::iterator pixelFrequencyMapsIterator = mPixelFrequencyMaps.begin(); pixelFrequencyMapsIterator != mPixelFrequencyMaps.end(); pixelFrequencyMapsIterator++) {
		map<int, int> pixelFrequencyMap = pixelFrequencyMapsIterator->second;
		
		for (map<int, int>::iterator pixelFrequencyMapIterator = pixelFrequencyMap.begin(); pixelFrequencyMapIterator != pixelFrequencyMap.end();
			 pixelFrequencyMapIterator++) {
			cout << pixelFrequencyMapsIterator->first << ": " << pixelFrequencyMapIterator->first << ": " << pixelFrequencyMapIterator->second << endl;
		}
	}
	
	cout << endl;
}

void TrainingFaceSet::printLikelihoodMaps() {
	for (map<int, map<int, double>>::iterator likelihoodMapsIterator = mLikelihoodMaps.begin(); likelihoodMapsIterator != mLikelihoodMaps.end(); likelihoodMapsIterator++) {
		map<int, double> likelihoodMap = likelihoodMapsIterator->second;
		
		for (map<int, double>::iterator likelihoodMapIterator = likelihoodMap.begin(); likelihoodMapIterator != likelihoodMap.end(); likelihoodMapIterator++) {
			cout << likelihoodMapsIterator->first << ": " << likelihoodMapIterator->first << ": " << likelihoodMapIterator->second << endl;
		}
	}
	
	cout << endl;
}

