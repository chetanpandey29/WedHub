//
//  MyUiButton.m
//  Trukker
//
//  Created by Kunj on 9/25/15.
//  Copyright © 2015 Flexiware Solutions. All rights reserved.
//

#import "MyUiButton.h"

@implementation UIButton (ButtonRoundCorner)

-(void) setCornerRadius:(int) Radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = Radius;
    self.layer.borderWidth = 0;
}


-(void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = TRUE;
}


@end
