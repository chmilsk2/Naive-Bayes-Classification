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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpNavigation];
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

#pragma mark - Prototypical Instnaces Button Touched

- (void)prototypicalInstancesButtonTouched {
	DigitPrototypicalInstancesViewController *prototypicalInstancesViewController = [[DigitPrototypicalInstancesViewController alloc] init];
	[self.navigationController pushViewController:prototypicalInstancesViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
