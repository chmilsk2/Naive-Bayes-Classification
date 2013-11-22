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
#include <map>

class FaceSet {
	vector<int> mFaceLabels;
	vector<Face> mFaces;
	map<int, int> mFrequencyMap;
	
public:
	FaceSet();
	FaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap);
	~FaceSet();
	
	// face labels
	vector<int> & faceLabels();
	
	// face label
	int faceLabel(int index);
	
	// faces
	vector<Face> & faces();
	
	// face
	Face & face(int index);
	
	// frequency map keeps track of the # of instances from each class
	map<int, int> & frequencyMap();
	int frequencyForClassIndex(int classIndex);
	
	// logging
	void printFrequencyMap();
};

#endif /* defined(__Face_Classification__FaceSet__) */
