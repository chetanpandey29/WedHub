//
//  RootViewController.m
//  LittleStarAdmin
//
//  Created by Kunj Patel on 9/28/15.
//  Copyright © 2015 Openxcell Technolabs. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


- (void)awakeFromNib
{
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
