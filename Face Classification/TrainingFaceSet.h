//
//  TrainingFaceSet.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__TrainingFaceSet__
#define __Face_Classification__TrainingFaceSet__

#include <iostream>
#include "FaceSet.h"
#include <map>

class TrainingFaceSet : public FaceSet {
	// frequency map keeps track of the # of instances from each class
	map<int, int> mFrequencyMap;
	
	// pixel frequency map keeps track of the pixel frequency map for each class
	map<int, int> mPixelFrequencyMap;
	
	// prior probabilities for each class
	map<int, double> mPriorProbabilityMaps;
	
	// likelihood maps keep track of P(Fij | class) for every pixel location (i,j) and for every class
	map<int, map<int, double>> mLikelihoodMaps;
	
public:
	TrainingFaceSet();
	TrainingFaceSet(vector<bool> faceLabels, vector<Face> faces);
	~TrainingFaceSet();
};

#endif /* defined(__Face_Classification__TrainingFaceSet__) */
