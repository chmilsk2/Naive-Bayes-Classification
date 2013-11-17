//
//  DigitSet.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitSet.h"
#include <math.h>


DigitSet::DigitSet() {}

DigitSet::~DigitSet() {}

void DigitSet::setBitShiftSizeUsingDigitSize(int digitSize) {
	// compute the number of bits necessary to represent the digitSize
	int bitShiftSize = 0;
	
	if (digitSize != 0) {
		int exponent = 0;
		int divisor = pow(2, exponent);
		bool shouldContinue = true;
		
		while (shouldContinue) {
			if (digitSize/divisor >= 1) {
				exponent++;
				divisor = pow(2, exponent);
			}
			
			else {
				shouldContinue = false;
				bitShiftSize = exponent;
			}
		}
	}
	
	mBitShiftSize = bitShiftSize;
}

map<int, int> DigitSet::pixelFrequencyMapForClassIndex(int classIndex) {
	map<int, int> pixelFrequencyMap = pixelFrequencyMaps[classIndex];
	
	return pixelFrequencyMap;
}

void DigitSet::updatePixelFrequencyMapUsingRowAndColumnForClassIndex(int row, int col, int classIndex) {
	map<int, int> pixelFrequencyMap = pixelFrequencyMaps[classIndex];
	int pixelIndex = (row << mBitShiftSize) + col;
	pixelFrequencyMap[pixelIndex]++;
	
	// pixelFrequencyMaps[classIndex] = pixelFrequencyMap;
}

void DigitSet::printFrequencyMap() {
	int total = 0;
	
	for (map<int, int>::iterator it = frequencyMap.begin(); it != frequencyMap.end(); it++) {
		cout << it->first << " => " << it->second << endl;
		
		total += it-> second;
	}
	
	cout << "total: " << total << endl;
}