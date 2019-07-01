//
//  AlertView.m
//  CCR
//
//  Created by Bharat Nakum on 10/2/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.
//

#import "AlertView.h"

#define KEY_TITLE   @"title"
#define KEY_MESSAGE @"message"

@interface AlertView() <UIAlertViewDelegate> {
    NSMutableArray *arrBlocks;
}
@end

@implementation AlertView

+ (AlertView *)sharedInstance {
    static AlertView *alertView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [[AlertView alloc] init];
    });
    return alertView;
}

- (void)showAlertForViewController:(UIViewController *)presentingController
                          withTitle:(NSString *)strTitle
                        andMessage:(NSString *)strMessage
           withArrayOfTotalActions:(NSArray *)arrActions
                     andCompletion:(blockCompletion)completionBlock {
    if (strTitle == nil) {
        strTitle = @"";
    }
    
    if (strMessage == nil) {
        strMessage = @"";
    }
    
    if (arrActions == nil) {
        arrActions = @[@"OK"];
    }
    
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                                 message:strMessage
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        for (NSString *strArrAction in arrActions) {
            UIAlertAction *actionAlert = [UIAlertAction actionWithTitle:strArrAction
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (completionBlock) {
                                                                     completionBlock(action.title);
                                                                    }
                                                                }];
            [alertController addAction:actionAlert];
        }
        
        [presentingController presentViewController:alertController
                                           animated:YES
                                         completion:nil];
    } else {
        if (arrBlocks == nil) {
            arrBlocks = [NSMutableArray array];
        }
        
        self.completionBlock = completionBlock;
        
        if (self.completionBlock) {
            [arrBlocks addObject:self.completionBlock];
        } else {
            [arrBlocks addObject:@""];
        }
        
        UIAlertView *alertController = [[UIAlertView alloc]
                                        initWithTitle:strTitle
                                        message:strMessage
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        
        
        
        for (NSString *strArrAction in arrActions)
        {
            [alertController addButtonWithTitle:strArrAction];
        }
        alertController.cancelButtonIndex = (arrActions.count - 1);
        [alertController show];
    }
}

- (void) showErrorAlertForViewController:(UIViewController *)presentingController
                             withMessage:(NSString *)strMessage {
    [self showAlertForViewController:presentingController
                           withTitle:nil
                          andMessage:strMessage
             withArrayOfTotalActions:nil
                       andCompletion:nil];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self manageBlocksArray];
    
    if (self.completionBlock) {
        self.completionBlock([alertView buttonTitleAtIndex:buttonIndex]);
    }
}

#pragma mark - Block Management
- (void)manageBlocksArray {
    if (arrBlocks.count > 0) {
        if ([arrBlocks[arrBlocks.count-1] isKindOfClass:[NSString class]]) {
            self.completionBlock = nil;
        } else {
            self.completionBlock = arrBlocks[arrBlocks.count-1];
        }
        [arrBlocks removeLastObject];
    }
}



@end
