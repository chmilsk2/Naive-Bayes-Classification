//
//  TrainingFaceSet.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "TrainingFaceSet.h"

TrainingFaceSet::TrainingFaceSet() {};

TrainingFaceSet::TrainingFaceSet(vector<bool> faceLabels, vector<Face> faces):FaceSet(faceLabels, faces) {};

TrainingFaceSet::~TrainingFaceSet() {};

#pragma mark - Prior Probabilities

