//
//  ColorRule.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__ColorRule__
#define __Face_Classification__ColorRule__

#include <iostream>

class ColorRule {
	
public:
	ColorRule();
	~ColorRule();
	
	void RGBColorForValue(char value, int *r, int *g, int *b);
};

#endif /* defined(__Face_Classification__ColorRule__) */
