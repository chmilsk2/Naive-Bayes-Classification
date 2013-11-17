//
//  DigitTrainingOperation.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "DigitSet.h"

typedef void(^DigitTrainingOperationHandler)();

@interface DigitTrainingOperation : NSOperation

@property (copy) DigitTrainingOperationHandler digitTrainingOperationCompletionBlock;

- (id)initWithDigitSet:(DigitSet)digitSet;

@end
