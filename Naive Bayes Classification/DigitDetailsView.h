//
//  DigitDetailsView.h
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DigitDetailsView;

@protocol DigitDetailsViewDataSource <NSObject>

- (NSInteger)digitClass;
- (UIColor *)pixelColorForDigitView:(DigitDetailsView *)digitDetailsView Row:(NSUInteger)row col:(NSUInteger)col;

@end

@protocol DigitDetailsViewDelegate <NSObject>

- (CGFloat)navigationBarHeight;
- (CGFloat)digitSize;

@end

@interface DigitDetailsView : UIView

- (void)setUpView;

@property (nonatomic, weak) id <DigitDetailsViewDataSource> dataSource;
@property (nonatomic, weak) id <DigitDetailsViewDelegate> delegate;

@end
