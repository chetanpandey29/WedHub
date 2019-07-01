//
//  LoginViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "SignUpViewController.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) NSString *stTitle;
- (IBAction)btnSignInClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwBAckground;


@property BOOL isReview;


@end
