//
//  Navigation.m
//  TrukkerLite
//
//  Created by Flexi_Mac2 on 5/04/2016.
//  Copyright © 2016 Flexiware. All rights reserved.
//

#import "Navigation.h"

@implementation Navigation
-(id)init{
    Navigation *nav=[super init];
    return nav;
}
+(UIStoryboard*)getStoryBord{
    
    UIStoryboard *storyboard;
    //
    //    if (IS_IPAD)
    //    {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
    //    }
    //    else
    //    {
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //   }
    
    return storyboard;
}
#pragma mark for CornerRadious
+(void)SetCorenerRedious : (UIView*)View :(UIRectCorner)corner{
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:View.bounds
                                     byRoundingCorners:corner
                                           cornerRadii:CGSizeMake(10.0,10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = View.superview.bounds;
    maskLayer.path = maskPath.CGPath;
    View.layer.mask = maskLayer;
}
@end
