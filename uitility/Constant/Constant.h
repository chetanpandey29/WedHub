//
//  Constant.h
//  Trukker
//
//  Created by Kunj on 3/4/16.
//  Copyright (c) 2015 Flexiware Solutions. All rights reserved.
//


#import "AppDelegate.h"
#import "AppUtils.h"
#import "WebServiceClass.h"
#import "UIImageView+WebCache.h"
#import "SBJson.h"

#ifndef Trukker_Constant_h
#define Trukker_Constant_h


#endif

/********************************************** Check Device Size ***********************************************/

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f || [[UIScreen mainScreen] bounds].size.width == 568.0f)

#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f || [[UIScreen mainScreen] bounds].size.width == 480.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f || [[UIScreen mainScreen] bounds].size.width == 667.0f)
#define IS_IPHONE_6_Plus (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f || [[UIScreen mainScreen] bounds].size.width == 736.0f)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IPHONE_6Plus (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f || [[UIScreen mainScreen] bounds].size.width == 736.0f)

/********************************************** Font ***********************************************/



/********************************************** Constants Names ***********************************************/


#define IosVersion7  [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0

#define IosVersiongreaterThan8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#define IosVersion8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0

#define Delegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height


#define WebServiceCall                      [WebServiceClass werserviceSharedManager]


#define AppUtilsShared                           [AppUtils sharedInstance]


#define APPBACKGROUD     [UIColor colorWithRed:252.0/255.0 green:115.0/255.0 blue:0.0/255.0 alpha:1 ]

#define AppColor     [UIColor colorWithRed:233.0/255.0 green:30.0/255.0 blue:99.0/255.0 alpha:1 ]

#define TextFieldBoarderColor    [[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0] CGColor]
/********************************************** Constants Color ***********************************************/


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]


#define ApplicationColor RGBACOLOR(0,0,0,1.0)


#define REDCOLOR            [UIColor redColor]


#define SUCCESSCOLOR        [UIColor colorWithRed:0.133f green:0.753f blue:0.392f alpha:1.00f]
