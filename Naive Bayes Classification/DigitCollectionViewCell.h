//
//  DigitCollectionViewCell.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DigitCollectionViewCell;

@protocol DigitCollectionViewDelegate <NSObject>

- (CGFloat)cellSize;

@end

@protocol DigitCollectionViewDataSource <NSObject>

- (UIColor *)pixelColorForDigitCell:(DigitCollectionViewCell *)digitCollectionViewCell Row:(NSUInteger)row col:(NSUInteger)col;

@end

@interface DigitCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <DigitCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <DigitCollectionViewDataSource> dataSource;
@property (nonatomic, strong) UIImageView *imageView;

@end
