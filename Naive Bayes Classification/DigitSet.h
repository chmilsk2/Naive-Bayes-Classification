//
//  DigitSet.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__DigitSet__
#define __Naive_Bayes_Classification__DigitSet__

#include <iostream>
#include <vector>
#include <map>
#include "Digit.h"

using namespace std;

class DigitSet {
	int mBitShiftSize;
	
	public:
		DigitSet();
		~DigitSet();
	
		Digit digitForRowAndColumn(int row, int col);
	
		// class frequency
		int frequencyForClassIndex(int classIndex);
	
		// pixel frequency
		map<int, int> pixelFrequencyMapForClassIndex(int classIndex);
		void updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, Digit digit, int classIndex);
		int pixelFrequencyForRowColumnAndClassIndex(int row, int col, int classIndex);
	
		// likelihoood
		map<int, double> likelihoodMapForClassIndex(int classIndex);
		void updateLikelihoodMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex, double likelihood);
	
		// bit shift size
		void setBitShiftSizeUsingDigitSize(int digitSize);
	
		// logging
		void printFrequencyMap();
		void printPixelFrequencyMaps();
		void printLikelihoodMaps();
	
		vector<int> digitLabels;
	
		// need digit vector to display digits in the the collection view
		vector<Digit> digits;
	
		// frequency map keeps track of the # of instances from each class
		map<int, int> frequencyMap;
	
		// pixel frequency maps keeps track of the pixel frequency map for each class
		map<int, map<int, int>> pixelFrequencyMaps;
	
		// likelihood maps keeps track of P(Fij | class) for every pixel location (i,j) and for every digit class from 0 to 9
		map<int, map<int, double>> likelihoodMaps;
	
	private:
		int pixelIndexForRowAndColumn(int row, int col);
};

#endif /* defined(__Naive_Bayes_Classification__DigitSet__) */
