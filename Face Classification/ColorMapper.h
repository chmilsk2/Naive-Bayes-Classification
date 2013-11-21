//
//  ColorMapper.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__ColorMapper__
#define __Face_Classification__ColorMapper__

#include <iostream>
#include "ColorRule.h"
#include <vector>

using namespace std;

class ColorMapper {
	ColorRule mColorRule;
	
public:
	ColorMapper();
	ColorMapper(ColorRule colorRule);
	~ColorMapper();
	
	vector<tuple<int, int, int>> colorMappedDataForData(vector<char> data);
};

#endif /* defined(__Face_Classification__ColorMapper__) */
