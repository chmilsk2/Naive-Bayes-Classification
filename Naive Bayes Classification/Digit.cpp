//
//  Digit.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Digit.h"
#include <math.h>

using namespace std;

Digit::Digit() {
	// -1 means the digit class has not yet been classified
	mDigitClass = -1;
}

Digit::~Digit() {}

int Digit::digitClass() {
	return mDigitClass;
}

void Digit::setDigitClass(int digitClass) {
	mDigitClass = digitClass;
}

void Digit::setPixelValue(int row, int col, char value) {
	mPixels[row][col] = value;
}

char Digit::pixelValue(int row, int col) {
	char pixelChar = mPixels[row][col];
	return pixelChar;
}

void Digit::printDigit() {
	for (int row = 0; row < DIGIT_SIZE; row++) {
		for (int col = 0; col < DIGIT_SIZE; col++) {
			cout << pixelValue(row, col) << " ";
		}
		
		cout << endl;
	}
}
