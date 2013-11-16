//
//  DigitCollectionViewController.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/9/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitCollectionViewCell.h"

@interface DigitCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DigitCollectionViewDataSource, DigitCollectionViewDelegate>

@end
