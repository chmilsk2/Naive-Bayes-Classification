//
//  FaceDataParser.cpp
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#include "FaceDataParser.h"
#include <fstream>

FaceDataParser::FaceDataParser() {};

FaceDataParser::FaceDataParser(const char *filePath):mFilePath(filePath) {};

FaceDataParser::~FaceDataParser() {};

vector<vector<char>> FaceDataParser::parseFaceData() {
	vector<vector<char>> faceDatas;
	
	string line;
	
	ifstream faceDataFile(mFilePath);
	
	int row = 0;
	
	if (faceDataFile.is_open()) {
		while (getline(faceDataFile, line)) {
			if (!row) {
				vector<char> faceData;
				faceDatas.push_back(faceData);
			}
			
			vector<char> faceData = faceDatas.back();
			
			for (auto it : line) {
				faceData.push_back(it);
			}
			
			faceDatas.back() = faceData;
			
			if (row == FACE_HEIGHT - 1) {
				row = 0;
			}
			
			else {
				row++;
			}
		}
	}
	
	return faceDatas;
}
