//
//  FaceSet.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "FaceSet.h"

FaceSet::FaceSet() {}

FaceSet::FaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap):mFaceLabels(faceLabels), mFaces(faces), mFrequencyMap(frequencyMap) {}

FaceSet::~FaceSet() {}

#pragma mark - Face Labels

vector<int> & FaceSet::faceLabels() {
	return mFaceLabels;
}

#pragma mark - Face Label

int FaceSet::faceLabel(int index) {
	int faceLabel = mFaceLabels[index];
	
	return faceLabel;
}

#pragma mark - Faces

vector<Face> & FaceSet::faces() {
	return mFaces;
}

#pragma mark - Face

Face & FaceSet::face(int index) {	
	return mFaces[index];
}

#pragma mark - Frequency

map<int, int> & FaceSet::frequencyMap() {
	return mFrequencyMap;
}

int FaceSet::frequencyForClassIndex(int classIndex) {
	int frequency = mFrequencyMap[classIndex];
	
	return frequency;
}

#pragma mark - Logging

void FaceSet::printFrequencyMap() {
	int total = 0;
	
	for (map<int, int>::iterator it = mFrequencyMap.begin(); it != mFrequencyMap.end(); it++) {
		cout << it->first << " => " << it->second << endl;
		
		total += it-> second;
	}
	
	cout << "total: " << total << endl;
	cout << endl;
}
