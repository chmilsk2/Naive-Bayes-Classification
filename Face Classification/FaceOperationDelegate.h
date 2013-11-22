//
//  FaceOperationDelegate.h
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FaceOperationDelegate <NSObject>

- (void)showProgressView;
- (void)setProgress:(float)progress;

@end
