//
//  FaceSet.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "FaceSet.h"

FaceSet::FaceSet() {};

FaceSet::FaceSet(vector<bool> faceLabels, vector<Face> faces):mFaceLabels(faceLabels), mFaces(faces) {};

FaceSet::~FaceSet() {};

#pragma mark - Face Label

bool FaceSet::faceLabel(int index) {
	bool isFace = mFaceLabels[index];
	
	return isFace;
}

#pragma mark - Face

Face FaceSet::face(int index) {
	Face face = mFaces[index];
	
	return face;
}
