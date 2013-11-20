//
//  DigitStatisticsViewController.m
//  Naive Bayes Classification
//
//  Created by Troy Chmieleski on 11/17/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DigitStatisticsViewController.h"
#import "DigitPrototypicalInstancesViewController.h"

#define PROTOTYPICAL_INSTANCES_BUTTON_TITLE @"Prototypical instances"

@implementation DigitStatisticsViewController {
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_prototypicalInstancesButton;
	ClassificationRule _classificationRule;
	DigitSet mDigitSet;
	UIColor *_backgroundColor;
}

- (id)initWithDigitSet:(DigitSet)digitSet classificationRule:(ClassificationRule)classificationRule {
	self = [super init];
	
	if (self) {
		_classificationRule = classificationRule;
		mDigitSet = digitSet;
		_backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
	[self.view setBackgroundColor:_backgroundColor];
}

- (void)setUpNavigation {
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
	[self.navigationItem setRightBarButtonItems:@[self.prototypicalInstancesButton] animated:YES];
}

#pragma mark - Cancel Button

- (UIBarButtonItem *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTouched)];
	}
	
	return _cancelButton;
}

#pragma mark - Cancel Button Touched

- (void)cancelButtonTouched {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Prototypical Instances Button

- (UIBarButtonItem *)prototypicalInstancesButton {
	if (!_prototypicalInstancesButton) {
		_prototypicalInstancesButton = [[UIBarButtonItem alloc] initWithTitle:PROTOTYPICAL_INSTANCES_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(prototypicalInstancesButtonTouched)];
	}
	
	return _prototypicalInstancesButton;
}

#pragma mark - Prototypical Instances Button Touched

- (void)prototypicalInstancesButtonTouched {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	DigitPrototypicalInstancesViewController *prototypicalInstancesViewController = [[DigitPrototypicalInstancesViewController alloc] initWithCollectionViewLayout:flowLayout DigitSet:mDigitSet classificationRule:_classificationRule];
	[self.navigationController pushViewController:prototypicalInstancesViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
