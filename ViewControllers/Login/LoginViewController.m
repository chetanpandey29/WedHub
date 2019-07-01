//
//  LoginViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "QMSettingsManager.h"
#import "QMViewControllersFactory.h"
#import "QMChatVC.h"
#import "QMApi.h"
@interface LoginViewController ()
{
    NSString *QuickEmail;
}

@end

@implementation LoginViewController
@synthesize stTitle,btnSignIn,txtEmailId,txtPassword,vwBAckground;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.hidden=NO;
    
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"SIGN IN"];
    self.navigationController.navigationBar.tintColor=AppColor;
    
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(btnSignUpClick:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 80, 31)];
    button.layer.cornerRadius = 10;//half of the width
    button.layer.borderColor=[UIColor whiteColor].CGColor;
    button.layer.borderWidth=1.0f;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 20)];
    [label setFont: [UIFont systemFontOfSize:14]];
    [label setText:@"SIGN UP"];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [AppUtilsShared setTextBoxBoarder:txtEmailId];
    [AppUtilsShared setTextBoxBoarder:txtPassword];
    
    [AppUtilsShared setButtonRadius:btnSignIn];
    
    btnSignIn.backgroundColor=AppColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnSignUpClick:(id)sender {
    SignUpViewController *objSignUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
   
    [self.navigationController pushViewController:objSignUpViewController animated:YES];

}
#pragma mark - TextField Delegate Methods
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField==txtEmailId)
    {
        

        
        return YES;
    }
    else if(textField ==txtPassword)
    {
        
     
        
        return YES;
    }
   
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
   
    
    
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{


    if (textField==txtEmailId)
    {
        [txtEmailId resignFirstResponder];
        [txtPassword becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtPassword)
    {
        [txtPassword resignFirstResponder];
      
        return NO;
        
    }
    else{
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
    
}
#pragma mark - Call WebService
#pragma mark
-(void)callLoginService
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@",txtEmailId.text],@"email",
                          [NSString stringWithFormat:@"%@",txtPassword.text],@"password",
                          @"Iphone",@"device",
                          nil];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Login" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            
            
            [SVProgressHUD show];
            NSLog(@"Response%@",response);
            
            [AppUtilsShared setPreferences:[[[response valueForKey:@"message"] objectAtIndex:0] valueForKey:@"MemberId"] withKey:@"MemberId"];
                   
            
            [AppUtilsShared setPreferences:txtPassword.text withKey:@"Password"];
             [AppUtilsShared setPreferences:txtEmailId.text withKey:@"Emailid"];
            [AppUtilsShared setPreferences:@"YES" withKey:@"autoLogin"];
             [AppUtilsShared setPreferences:[[[response valueForKey:@"message"] objectAtIndex:0] valueForKey:@"UserType"] withKey:@"UserType"];
            
            
           
            QuickEmail = txtEmailId.text;
      
                   [[QMApi instance] loginWithEmail:QuickEmail password:@"admin@123" rememberMe:YES completion:^(BOOL success)  {
                // Success, do something
                       NSLog(@"Login Successfully");
                           [Delegate registerForRemoteNotifications];
                       
                                          if(_isReview==NO) // if Not from Review screen
                       {
                           DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                           
                           [self.navigationController pushViewController:objDashboardViewController animated:YES];
                       }
                       else
                       {
                           ReviewViewController *objReviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
                           
                           [self.navigationController pushViewController:objReviewViewController animated:YES];
                       }
                    
                
                       
                       [SVProgressHUD dismiss];
                 }];
        }
        
             }];
           }


#pragma mark - Action
#pragma mark
- (IBAction)btnSignInClick:(id)sender
{
    [self.view endEditing:YES];
    if ([self Validate])
    {
        [self callLoginService];

    }
}

-(BOOL)Validate
{
    if ([txtEmailId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0 || ![AppUtilsShared validateEmailWithString:txtEmailId.text])
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Valid EmailId" withcolor:AppColor];
        return NO;
    }
    if ([txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Password" withcolor:AppColor];
        return NO;
    }
    return YES;
}
@end
