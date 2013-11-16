//
//  DigitCollectionViewCell.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitCollectionViewCell.h"

@implementation DigitCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) {
        // Initialization code
    }
	
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGFloat cellSize = 0;
	
	if ([self.delegate respondsToSelector:@selector(cellSize)]) {
		cellSize = [self.delegate cellSize];
	}
	
	// the 'pixel' in this case is each individual colored cell within each digit
	// it is strectched by a multiplier value
	CGFloat stretchedPixelSize = self.frame.size.width/cellSize;
	
	for (NSUInteger row = 0; row < cellSize; row++) {
		for (NSUInteger col = 0; col < cellSize; col++) {
			UIColor *fillColor;
			
			if ([self.dataSource respondsToSelector:@selector(pixelColorForDigitCell:Row:col:)]) {
				fillColor = [self.dataSource pixelColorForDigitCell:self Row:row col:col];
				CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
				CGContextFillRect(ctx, CGRectMake(col*stretchedPixelSize, row*stretchedPixelSize, stretchedPixelSize, stretchedPixelSize));
			}
		}
	}
}

@end
