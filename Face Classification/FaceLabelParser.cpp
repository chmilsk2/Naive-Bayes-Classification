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

vector<bool> FaceLabelParser::parseFaceLabels() {
	vector<bool> faceLabels;
	
	string line;
	
	ifstream faceLabelFile(mFilePath);
	
	if (faceLabelFile.is_open()) {
		while (getline(faceLabelFile, line)) {
			int labelIntValue = atoi(line.c_str());
			bool labelValue;
			
			if (labelIntValue == 0) {
				labelValue = false;
			}
			
			else {
				labelValue = true;
			}
			
			faceLabels.push_back(labelValue);
		}
	}

	return faceLabels;
}