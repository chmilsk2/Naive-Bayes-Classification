
//
//  DigitParser.cpp
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "DigitParser.h"
#include "Digit.h"
#include <fstream>

using namespace std;

DigitParser::DigitParser(const char * filePath):mFilePath(filePath) {}

DigitParser::~DigitParser() {}

void DigitParser::parseDigits(DigitSet &digitSet) {
	string line;
	
	ifstream digitsFile(mFilePath);
	
	int row = 0;
	
	if (digitsFile.is_open()) {
		while (getline(digitsFile, line)) {
			if (!row) {
				Digit digit;
				digitSet.digits.push_back(digit);
			}
			
			Digit digit = digitSet.digits.back();
			
			int col = 0;
			
			for (string::iterator it = line.begin(); it != line.end(); ++it) {
				char value = *it;
				
				digit.setPixelValue(row, col, value);
				
				col++;
			}
			
			digitSet.digits.back() = digit;
			
			if (row == DIGIT_SIZE - 1) {
				row = 0;
			}
			
			else {
				row++;
			}
		}
	}
}

