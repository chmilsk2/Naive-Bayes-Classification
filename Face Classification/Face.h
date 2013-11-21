//
//  Face.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__Face__
#define __Face_Classification__Face__

#include <iostream>
#include <tuple>
#include <vector>

using namespace std;

typedef struct FaceData {
	vector<char> data;
	vector<tuple<int, int, int>> colorMappedData;
} FaceData;

class Face {
	FaceData mFaceData;
	bool mIsFace;
	
public:
	Face();
	Face(vector<char> data, bool isFace);
	~Face();
	
	// face data
	FaceData faceData();
	
	// is face
	bool isFace();
	
	tuple<int, int, int> colorForRowCol(int row, int col);
	void setColorMappedData(vector<tuple<int, int, int>> colorMappedData);
};

#endif /* defined(__Face_Classification__Face__) */
