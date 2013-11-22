//
//  FaceCollectionViewCell.m
//  Face Classification
//
//  Created by Troy Chmieleski on 11/20/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "FaceCollectionViewCell.h"

#define LABEL_HEIGHT_FACTOR 4;
#define CLASSIFICATION_LABEL_FONT_SIZE 12.0f

@implementation FaceCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setUpImageView];
		[self setUpClassificationLabel];
    }
	
    return self;
}

- (void)setUpImageView {
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.clipsToBounds = YES;
	
	[self.contentView addSubview:_imageView];
}

- (void)setUpClassificationLabel {
	_classificationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_classificationLabel setTextAlignment:NSTextAlignmentCenter];
	[_classificationLabel setFont:[UIFont systemFontOfSize:CLASSIFICATION_LABEL_FONT_SIZE]];
	
	[self.contentView addSubview:_classificationLabel];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
	
    self.imageView.image = nil;
}

- (void)layoutSubviews {
	// layout image view
	
	CGSize imageSize = CGSizeMake(FACE_WIDTH, FACE_HEIGHT);
	
	[_imageView setFrame:CGRectMake((self.bounds.size.width - imageSize.width)/2, 0, imageSize.width, imageSize.height)];
	
	// layout classification label
	CGFloat labelHeight = CLASSIFICATION_LABEL_FONT_SIZE;
	[_classificationLabel setFrame:CGRectMake(0, imageSize.height + (self.bounds.size.height - imageSize.height - labelHeight)/2, self.bounds.size.width, labelHeight)];
}

@end
