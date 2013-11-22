//
//  FaceLabelParser.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "FaceLabelParser.h"
#import <fstream>

FaceLabelParser::FaceLabelParser() {};

FaceLabelParser::FaceLabelParser(const char *filePath):mFilePath(filePath) {};

FaceLabelParser::~FaceLabelParser() {};

vector<int> FaceLabelParser::parseFaceLabels() {
	vector<int> faceLabels;
	
	string line;
	
	ifstream faceLabelFile(mFilePath);
	
	if (faceLabelFile.is_open()) {
		while (getline(faceLabelFile, line)) {
			int labelValue = atoi(line.c_str());
			
			faceLabels.push_back(labelValue);
		}
	}

	return faceLabels;
}