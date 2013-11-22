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
	// bit shift size
	int mBitShiftSize;

	// pixel frequency map keeps track of the pixel frequency map for each class
	map<int, map<int, int>> mPixelFrequencyMaps;
	
	// prior probabilities for each class
	map<int, double> mPriorProbabilityMap;
	
	// likelihood maps keep track of P(Fij | class) for every pixel location (i,j) and for every class
	map<int, map<int, double>> mLikelihoodMaps;
	
public:
	TrainingFaceSet();
	TrainingFaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap);
	~TrainingFaceSet();
	
	// pixel frequency
	map<int, int> & pixelFrequencyMapForClassIndex(int classIndex);
	void updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, Face & face, int classIndex);
	int pixelFrequencyForRowColumnAndClassIndex(int row, int col, int classIndex);
	
	// prior probabilities
	map<int, double> & priorProbabilityMap();
	void updatePriorProbabilityForClassIndex(int classIndex);
	
	// likelihoood
	map<int, double> & likelihoodMapForClassIndex(int classIndex);
	void updateLikelihoodMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex, double likelihood);
	double likelihoodForRowColumnAndClassIndex(int row, int col, int classIndex);
	
	void printPixelFrequencyMaps();
	void printLikelihoodMaps();
	
private:
	int bitShiftSizeUsingFaceSize(int width, int height);
	int pixelIndexForRowAndColumn(int row, int col);
};

#endif /* defined(__Face_Classification__TrainingFaceSet__) */
