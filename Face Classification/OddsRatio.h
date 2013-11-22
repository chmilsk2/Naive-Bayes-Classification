//
//  OddsRatio.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__OddsRatio__
#define __Face_Classification__OddsRatio__

#include <iostream>

#include <iostream>
#include <map>
#include <tuple>

using namespace std;

enum OddsRatioType {
	OddsRatioTypeLikelihood1,
	OddsRatioTypeLikelihood2,
	OddsRatioTypeRatio
};

class OddsRatio {
	int mFirstFaceClass;
	int mSecondFaceClass;
	
	// color maps
	map<int, tuple<int, int, int>> mLikelihood1ColorMap;
	map<int, tuple<int, int, int>> mLikelihood2ColorMap;
	map<int, tuple<int, int, int>> mOddsRatioColorMap;
	
public:
	OddsRatio();
	~OddsRatio();
	
	// first face class
	int firstFaceClass();
	void setFirstFaceClass(int faceClass);
	
	// second face class
	int secondFaceClass();
	void setSecondFaceClass(int faceClass);
	
	// set RGB values for likelihood
	tuple<int, int, int> RGBValuesForRowColAndOddsRatioType(int row, int col, OddsRatioType oddsRatioType);
	void setRGBValuesForLogLikelihood(double logLikelihood, double mostNegativeLogValue, double mostPositiveLogValue, int row, int col, OddsRatioType oddsRatioType);
	
	// color maps
	map<int, tuple<int, int, int>> & likelihood1ColorMap();
	map<int, tuple<int, int, int>> & likelihood2ColorMap();
	map<int, tuple<int, int, int>> & oddsRatioColorMap();
	
private:
	void heatMapColor(float value, int *red, int *green, int *blue);
	double normalizedValueWithRange(double value, double mostNegativeValue, double mostPositiveValue);
};


#endif /* defined(__Face_Classification__OddsRatio__) */
