//
//  RootNavigationController.m
//  LittleStarAdmin
//
//  Created by Kunj Patel on 9/28/15.
//  Copyright © 2015 Openxcell Technolabs. All rights reserved.
//

#import "RootNavigationController.h"

@implementation RootNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark
#pragma mark - Gesture recognizer
#pragma mark

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.panGestureEnabled = YES;
    // Present the view controller
    
    [self.frostedViewController panGestureRecognized:sender];
}

@end
