//
//  Face.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__Face__
#define __Face_Classification__Face__

#include <iostream>
#include <tuple>
#include <vector>
#include <map>

using namespace std;

enum ClassificationType {
	ClassificationTypeNone,
	ClassificationTypeCorrect,
	ClassificationTypeIncorrect
};

typedef struct FaceData {
	vector<char> data;
	vector<tuple<int, int, int>> colorMappedData;
} FaceData;

class Face {
	FaceData mFaceData;
	int mFaceClass;
	map<int, double> mMaximumAPosterioriMap;
	map<int, double> mMaximumLikelihoodMap;
	ClassificationType mClassificationType;
	
public:
	Face();
	Face(vector<char> data, int faceClass);
	~Face();
	
	// face data
	FaceData faceData();
	char pixelValue(int row, int col);
	
	// face class
	int faceClass();
	void setFaceClass(int faceClass);
	
	// classification type
	ClassificationType classificationType();
	void setClassificationType(ClassificationType classificationType);
	
	// pixel color
	tuple<int, int, int> colorForRowCol(int row, int col);
	void setColorMappedData(vector<tuple<int, int, int>> colorMappedData);
	
	// MAP classification
	double maximumAPosterioriProbabilityForClassIndex(int classIndex);
	void setMaximumAPosterioriProbabilityForClassIndex(int classIndex, double maximumAPosterioiProbability);
	
	// ML classification
	double maximumLikelihoodProbabilityForClassIndex(int classIndex);
	void setMaximumLikelihoodProbabilityForClassIndex(int classIndex, double maximumLikelihoodProbability);
	
	// logging
	void printFace();
	void printMaximumAPosterioriMap();
	void printMaximumLikelihoodMap();
};

#endif /* defined(__Face_Classification__Face__) */
