//
//  FaceDataParser.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__FaceDataParser__
#define __Face_Classification__FaceDataParser__

#include <iostream>
#include <vector>

using namespace std;

class FaceDataParser {
	const char *mFilePath;
	
public:
	FaceDataParser();
	FaceDataParser(const char *filePath);
	~FaceDataParser();
	
	vector<vector<char>> parseFaceData();
};

#endif /* defined(__Face_Classification__FaceDataParser__) */
