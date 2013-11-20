//
//  DigitStatisticsViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitSet.h"
#import "DigitClassificaitonRule.h"

@interface DigitStatisticsViewController : UIViewController

- (id)initWithDigitSet:(DigitSet)digitSet classificationRule:(ClassificationRule)classificationRule;

@end
