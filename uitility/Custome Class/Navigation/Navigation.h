//
//  Navigation.h
//  TrukkerLite
//
//  Created by Flexi_Mac2 on 5/04/2016.
//  Copyright © 2016 Flexiware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Navigation : NSObject
-(id)init;
+(UIStoryboard*)getStoryBord;

+(void)SetCorenerRedious : (UIView*)View :(UIRectCorner)corner;

@end
