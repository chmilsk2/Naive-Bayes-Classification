//
//  Face.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "Face.h"

Face::Face() {};

Face::Face(vector<char> data, bool isFace) {
	mFaceData.data = data;
	mIsFace = isFace;
};

Face::~Face() {};

#pragma mark - Face Data

FaceData Face::faceData() {
	return mFaceData;
}

#pragma mark - Is Face

bool Face::isFace() {
	return mIsFace;
}

#pragma mark - Color Map

tuple<int, int, int> Face::colorForRowCol(int row, int col) {
	int offset = row*FACE_WIDTH + col;
	
	return mFaceData.colorMappedData[offset];
}

void Face::setColorMappedData(vector<tuple<int, int, int>> colorMappedData) {
	mFaceData.colorMappedData = colorMappedData;
}

