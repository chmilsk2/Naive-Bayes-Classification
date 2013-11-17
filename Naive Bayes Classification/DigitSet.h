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
		map<int, int> pixelFrequencyMapForClassIndex(int classIndex);
		void updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex);
		void setBitShiftSizeUsingDigitSize(int digitSize);
		void printFrequencyMap();
	
		vector<int> digitLabels;
	
		// need digit vector to display digits in the the collection view
		vector<Digit> digits;
	
		// frequency map keeps track of the # of instances from each class
		map<int, int> frequencyMap;
	
#warning TODO: implement access to the pixelFrequencyMaps
		vector<map<int, int>> pixelFrequencyMaps;
};

#endif /* defined(__Naive_Bayes_Classification__DigitSet__) */
