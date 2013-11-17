//
//  DigitTestingOperation.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitTestingOperation.h"

@implementation DigitTestingOperation

- (void)main {
	[self test];
	
	[self didFinishTesting];
}

- (void)test {
	NSLog(@"testing");
}

- (void)didFinishTesting {
	if (self.digitTestingOperationCompletionBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.digitTestingOperationCompletionBlock();
		});
	}
}

@end
