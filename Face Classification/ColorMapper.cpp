//
//  ColorMapper.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "ColorMapper.h"

ColorMapper::ColorMapper() {};

ColorMapper::ColorMapper(ColorRule colorRule):mColorRule(colorRule) {};

ColorMapper::~ColorMapper() {};

vector<tuple<int, int, int>> ColorMapper::colorMappedDataForData(vector<char> data) {
	vector<tuple<int, int, int>> colorMappedData;
	
	for (auto it : data) {
		int *r = new int;
		int *g = new int;
		int *b = new int;
		
		mColorRule.RGBColorForValue(it, r, g, b);
		
		int red = *r;
		int green = *g;
		int blue = *b;
		
		colorMappedData.push_back(tuple<int, int, int>(red, green, blue));
		
		delete r;
		delete g;
		delete b;
	}
	
	return colorMappedData;
}
