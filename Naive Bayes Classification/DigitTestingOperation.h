//
//  DigitTestingOperation.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigitOperationDelegate.h"

typedef void(^DigitTestingOperationHandler)();

@interface DigitTestingOperation : NSOperation

@property (copy) DigitTestingOperationHandler digitTestingOperationCompletionBlock;
@property (nonatomic, weak) id <DigitOperationDelegate> delegate;

@end
