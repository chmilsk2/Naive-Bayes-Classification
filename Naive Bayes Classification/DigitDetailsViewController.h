//
//  DigitDetailsViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Digit.h"
#import "DigitDetailsView.h"

@interface DigitDetailsViewController : UIViewController <DigitDetailsViewDataSource, DigitDetailsViewDelegate>

- (id)initWithDigit:(Digit)digit;

@end
