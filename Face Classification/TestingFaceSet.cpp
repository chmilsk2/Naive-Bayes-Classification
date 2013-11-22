//
//  TestingFaceSet.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "TestingFaceSet.h"
#include <float.h>

TestingFaceSet::TestingFaceSet() {};

TestingFaceSet::TestingFaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap):FaceSet(faceLabels, faces, frequencyMap) {};

TestingFaceSet::~TestingFaceSet() {};

#pragma mark - Prototypical Maximum A Posteriori Face Index Map

map<int, int> & TestingFaceSet::prototypicalMaximumAPosterioriFaceIndexMap() {
	return mPrototypicalMaximumAPosterioriFaceIndexMap;
}

#pragma mark - Prototypical Maximum Likelihood Face Index Map

map<int, int> & TestingFaceSet::prototypicalMaximumLikelihoodFaceIndexMap() {
	return mPrototypicalMaximumAPosterioriFaceIndexMap;
}

#pragma mark - Logging

void TestingFaceSet::printPrototypicalMaximumAPosterioriFaceIndexMap() {
	cout << "Prototypical Maximum A Posteriori Face Index Map" << endl;
	
	for (auto it : mPrototypicalMaximumAPosterioriFaceIndexMap) {
		cout << it.first << ": " << it.second << endl;
	}
	
	cout << endl;
}

void TestingFaceSet::printPrototypicalMaximumLikelihoodFaceIndexMap() {
	cout << "Prototypical Maximum Likelihood Face Index Map" << endl;
	
	for (auto it : mPrototypicalMaximumLikelihoodFaceIndexMap) {
		cout << it.first << ": " << it.second << endl;
	}
	
	cout << endl;
}


