//
//  FaceSet.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__FaceSet__
#define __Face_Classification__FaceSet__

#include <iostream>
#include "Face.h"
#include <vector>

class FaceSet {
	vector<bool> mFaceLabels;
	vector<Face> mFaces;
	
public:
	FaceSet();
	FaceSet(vector<bool> faceLabels, vector<Face> faces);
	~FaceSet();
	
	// face label
	bool faceLabel(int index);
	
	// face
	Face face(int index);
};

#endif /* defined(__Face_Classification__FaceSet__) */
