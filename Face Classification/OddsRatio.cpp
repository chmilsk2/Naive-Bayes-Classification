//
//  OddsRatio.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "OddsRatio.h"
#include <math.h>

#pragma mark - Public

OddsRatio::OddsRatio() {};

OddsRatio::~OddsRatio() {};

#pragma mark - First Face Class

int OddsRatio::firstFaceClass() {
	return mFirstFaceClass;
}

void OddsRatio::setFirstFaceClass(int FaceClass) {
	mFirstFaceClass = FaceClass;
}

#pragma mark - Second Face Class

int OddsRatio::secondFaceClass() {
	return mSecondFaceClass;
}

void OddsRatio::setSecondFaceClass(int FaceClass) {
	mSecondFaceClass = FaceClass;
}

#pragma mark - Color Maps

map<int, tuple<int, int, int>> & OddsRatio::likelihood1ColorMap() {
	return mLikelihood1ColorMap;
}

map<int, tuple<int, int, int>> & OddsRatio::likelihood2ColorMap() {
	return mLikelihood2ColorMap;
}

map<int, tuple<int, int, int>> & OddsRatio::oddsRatioColorMap() {
	return mOddsRatioColorMap;
}

#pragma mark - RGB Values for Likelihood

tuple<int, int, int> OddsRatio::RGBValuesForRowColAndOddsRatioType(int row, int col, OddsRatioType oddsRatioType) {
	tuple<int, int, int> pixelColor;
	
	int offset = row*FACE_WIDTH + col;
	
	if (oddsRatioType == OddsRatioTypeLikelihood1) {
		pixelColor = mLikelihood1ColorMap[offset];
	}
	
	else if (oddsRatioType == OddsRatioTypeLikelihood2) {
		pixelColor = mLikelihood2ColorMap[offset];
	}
	
	else if (oddsRatioType == OddsRatioTypeRatio) {
		pixelColor = mOddsRatioColorMap[offset];
	}
	
	return pixelColor;
}

void OddsRatio::setRGBValuesForLogLikelihood(double logLikelihood, double mostNegativeLogValue, double mostPositiveLogValue, int row, int col, OddsRatioType oddsRatioType) {
	// normalize the value between 0 and 1
	double normalizedValue = normalizedValueWithRange(logLikelihood, mostNegativeLogValue, mostPositiveLogValue);
	
	int *r = new int;
	int *g = new int;
	int *b = new int;
	
	heatMapColor((float)normalizedValue, r, g, b);
	
	int red = *r;
	int green = *g;
	int blue = *b;
	
	int offset = row*FACE_WIDTH + col;
	
	tuple<int, int, int> pixelColor(red, green, blue);
	
	if (oddsRatioType == OddsRatioTypeLikelihood1) {
		mLikelihood1ColorMap[offset] = pixelColor;
	}
	
	else if (oddsRatioType == OddsRatioTypeLikelihood2) {
		mLikelihood2ColorMap[offset] = pixelColor;
	}
	
	else if (oddsRatioType == OddsRatioTypeRatio) {
		mOddsRatioColorMap[offset] = pixelColor;
	}
	
	delete r;
	delete g;
	delete b;
}

#pragma mark - Private

#pragma mark - Heat Map Color

void OddsRatio::heatMapColor(float value, int *red, int *green, int *blue) {
	const int numColors = 5;
	const int numColorComponents = 3;
	
	// A static array of 5 colors:  (blue, cyan, green, yellow, red) using {r,g,b} for each.
	static float colors[numColors][numColorComponents] = { {0,0,1}, {0,1,1}, {0,1,0}, {1,1,0}, {1,0,0} };
	
	// desired color will be between these two indices in the color array
	int index1;
	int index2;
	
	// fraction between index 1 and index 2 where the desired value is
	float fractionBetween = 0;
	
	// accounts for inputs <= 0
	if (value <= 0) {
		index1 = index2 = 0;
	}
	
	// accounts for inputs >= 1
	else if (value >= 1) {
		index1 = index2 = numColors - 1;
	}
	
	else {
		value = value * (numColors - 1);
		
		// desired color will be after this index
		index1 = floor(value);
		
		// desired color will be before this index
		index2 = index1 + 1;
		
		// distance between the two indices (0-1)
		fractionBetween = value - float(index1);
	}
	
	float r = (colors[index2][0] - colors[index1][0])*fractionBetween + colors[index1][0];
	float g = (colors[index2][1] - colors[index1][1])*fractionBetween + colors[index1][1];
	float b = (colors[index2][2] - colors[index1][2])*fractionBetween + colors[index1][2];
	
	*red = (int)(r*255);
	*green = (int)(g*255);
	*blue = (int)(b*255);
}

#pragma mark - Normalized Value

double OddsRatio::normalizedValueWithRange(double value, double mostNegativeValue, double mostPositiveValue) {
	double normalizedValue = 0;
	
	// norm_data = (value - min(value)) / (max(value) - min(value))
	normalizedValue = (value - mostNegativeValue)/(mostPositiveValue - mostNegativeValue);
	
	return normalizedValue;
}