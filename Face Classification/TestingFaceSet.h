//
//  TestingFaceSet.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/21/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#ifndef __Face_Classification__TestingFaceSet__
#define __Face_Classification__TestingFaceSet__

#include <iostream>
#include "FaceSet.h"
#include <map>

class TestingFaceSet : public FaceSet {
	map<int, int> mPrototypicalMaximumAPosterioriFaceIndexMap;
	map<int, int> mPrototypicalMaximumLikelihoodFaceIndexMap;
	
public:
	TestingFaceSet();
	TestingFaceSet(vector<int> faceLabels, vector<Face> faces, map<int, int> frequencyMap);
	~TestingFaceSet();

	// prototypical MAP index map
	map<int, int> & prototypicalMaximumAPosterioriFaceIndexMap();
	
	// prototypical ML face index map
	map<int, int> & prototypicalMaximumLikelihoodFaceIndexMap();
	
	// logging
	void printPrototypicalMaximumAPosterioriFaceIndexMap();
	void printPrototypicalMaximumLikelihoodFaceIndexMap();
};


#endif /* defined(__Face_Classification__TestingFaceSet__) */
