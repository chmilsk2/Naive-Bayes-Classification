//
//  Digit.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/10/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Naive_Bayes_Classification__Digit__
#define __Naive_Bayes_Classification__Digit__

#include <iostream>

#define DIGIT_SIZE 28

class Digit {
	int mDigitClass;
	char mPixels[DIGIT_SIZE][DIGIT_SIZE];
	
	public:
		Digit();
		~Digit();
		int digitClass();
		void setDigitClass(int digitClass);
		char pixelValue(int row, int col);
		void setPixelValue(int row, int col, char value);
		void printDigit();
};

#endif /* defined(__Naive_Bayes_Classification__Digit__) */
