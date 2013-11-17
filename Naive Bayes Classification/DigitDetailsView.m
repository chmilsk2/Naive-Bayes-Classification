//
//  DigitDetailsView.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/16/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitDetailsView.h"

#define DIGIT_DETAILS_STRETCHED_PIXEL_SIZE 12.0f
#define DIGIT_DETAILS_FONT_SIZE 36.0f
#define DIGIT_DETAILS_VERTICAL_MARGIN 14.0f
#define DIGIT_DETAILS_CLASSIFICATION_PREFIX_TEXT @"Class: "
#define DIGIT_DETAILS_NO_CLASSIFICATION_TEXT @"Not yet classified"

@implementation DigitDetailsView {
	UILabel *_digitClassLabel;
	UIFont *_font;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1.0]];
		_font = [UIFont systemFontOfSize:DIGIT_DETAILS_FONT_SIZE];
    }
	
    return self;
}

- (void)setUpView {
	[self addSubview:self.digitClassLabel];
}

#pragma mark - Digit Class Label

- (UILabel *)digitClassLabel {
	if (!_digitClassLabel) {
		_digitClassLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		NSString *digitClassText = @"";
		
		if ([self.dataSource respondsToSelector:@selector(digitClass)]) {
			NSInteger digitClass = [self.dataSource digitClass];
			
			if (digitClass == -1) {
				digitClassText = [NSString stringWithFormat:@"%@%@", DIGIT_DETAILS_CLASSIFICATION_PREFIX_TEXT, DIGIT_DETAILS_NO_CLASSIFICATION_TEXT];
			}
			
			else {
				digitClassText = [NSString stringWithFormat:@"%@%ld", DIGIT_DETAILS_CLASSIFICATION_PREFIX_TEXT, (long)digitClass];
			}
		}
		
		[_digitClassLabel setText:digitClassText];
		[_digitClassLabel setFont:_font];
		[_digitClassLabel setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _digitClassLabel;
}

- (void)layoutSubviews {
	// set digit frame
	
	NSLog(@"%@", NSStringFromCGRect(self.frame));
	
	// set digit label frame
	[_digitClassLabel setFrame:CGRectMake(0, self.frame.size.height - _font.pointSize - DIGIT_DETAILS_VERTICAL_MARGIN, self.frame.size.width, _font.pointSize)];
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGFloat navigationBarHeight = 0;
	
	if ([self.delegate respondsToSelector:@selector(navigationBarHeight)]) {
		navigationBarHeight = [self.delegate navigationBarHeight];
	}
	
	CGFloat digitSize = 0;
	
	if ([self.delegate respondsToSelector:@selector(digitSize)]) {
		digitSize = [self.delegate digitSize];
	}
	
	for (NSUInteger row = 0; row < digitSize; row++) {
		for (NSUInteger col = 0; col < digitSize; col++) {
			UIColor *fillColor;
			
			if ([self.dataSource respondsToSelector:@selector(pixelColorForDigitView:Row:col:)]) {
				fillColor = [self.dataSource pixelColorForDigitView:self Row:row col:col];
				CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
				
				CGFloat horizontalMargin = (self.frame.size.width - digitSize*DIGIT_DETAILS_STRETCHED_PIXEL_SIZE)/2;
				CGFloat verticalMargin = (self.frame.size.height - navigationBarHeight - digitSize*DIGIT_DETAILS_STRETCHED_PIXEL_SIZE)/2;
				
				CGContextFillRect(ctx, CGRectMake(horizontalMargin + col*DIGIT_DETAILS_STRETCHED_PIXEL_SIZE, verticalMargin + row*DIGIT_DETAILS_STRETCHED_PIXEL_SIZE, DIGIT_DETAILS_STRETCHED_PIXEL_SIZE, DIGIT_DETAILS_STRETCHED_PIXEL_SIZE));
			}
		}
	}
}


@end
