//
//  FaceLabelParser.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__FaceLabelParser__
#define __Face_Classification__FaceLabelParser__

#include <iostream>
#include <vector>

using namespace std;

class FaceLabelParser {
	const char *mFilePath;
public:
	FaceLabelParser();
	FaceLabelParser(const char *filePath);
	~FaceLabelParser();
	
	vector<int> parseFaceLabels();
};

#endif /* defined(__Face_Classification__FaceLabelParser__) */
