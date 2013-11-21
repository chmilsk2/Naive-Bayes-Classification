//
//  ColorRule.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "ColorRule.h"

ColorRule::ColorRule() {};

ColorRule::~ColorRule() {};

#pragma mark - Color for Value

void ColorRule::RGBColorForValue(char value, int *r, int *g, int *b) {
	// possible characters are '#', ' '
	
	if (value == '#') {
		*r = 0;
		*g = 0;
		*b = 0;
	}
	
	else if (value == ' ') {
		*r = 255;
		*g = 255;
		*b = 255;
	}
}
