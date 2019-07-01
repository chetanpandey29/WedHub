//
//  AlertView.h
//  CCR
//
//  Created by Bharat Nakum on 10/2/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^blockCompletion)(NSString *strActions);

@interface AlertView : NSObject

@property (nonatomic,copy) blockCompletion completionBlock;

+ (AlertView *)sharedInstance;

- (void)showAlertForViewController:(UIViewController *)presentingController
                         withTitle:(NSString *)strTitle
                        andMessage:(NSString *)strMessage
           withArrayOfTotalActions:(NSArray *)arrActions
                     andCompletion:(blockCompletion)completionBlock;

- (void)showErrorAlertForViewController:(UIViewController *)presentingController
                             withMessage:(NSString *)strMessage;




@end
