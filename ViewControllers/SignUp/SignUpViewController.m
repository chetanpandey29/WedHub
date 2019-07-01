//
//  SignUpViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    NSMutableArray *arrCategory,*arrLocation,*arrLoc;
    WYPopoverController  *popoverController;
    NSString *userType,*stLocationId,*stNewLocation;
    NSString *stCategoryId;
    BOOL isopen;
    UITableView *tblLocation;
    
}
@end

@implementation SignUpViewController
@synthesize progressBarPriceRange,txtName,txtEmail,txtPassword,txtConfirmPassword,txtCategory,txtFacebook,txtInstagram,txtLocation,txtSnapChat,txtTwitter,btnCoupleCheck,btnVendorCheck,btnCreateAccount,tvShortBio,constCategoryHeight,constCategoryTop,constFacebookHeight,constFacebookTop,constInstaHeight,constInstaTop,constlblPriceHeight,constlblPriceTop,constSliderHeight,constSnapchatHeight,constSnapchatTop,constTwitterHeight,constTwitterTop,ScrollView,txtMaxPrice,txtMinPrice,constMaxPriceTop,constMinPriceTop,constMaxPriceHeight,constMinPriceHeight,constTvShortBio;
- (void)viewDidLoad {
    [super viewDidLoad];
    stLocationId=@"";
    stNewLocation=@"";
    arrLocation=[[NSMutableArray alloc]init];
    arrLoc=[[NSMutableArray alloc]init];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(btnSignInClick:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 80, 31)];
    button.layer.cornerRadius = 10;//half of the width
    button.layer.borderColor=[UIColor whiteColor].CGColor;
    button.layer.borderWidth=1.f;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 80, 20)];
    [label setFont: [UIFont systemFontOfSize:14]];
    [label setText:@"SIGN IN"];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"SIGN UP"];
    self.navigationController.navigationBar.tintColor=AppColor;

    
    
    [self TextfieldBoarder];
    
    
    
    UITapGestureRecognizer *TapRecognizerVendorCheck = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (handleTapSelect:)];
    [TapRecognizerVendorCheck setNumberOfTouchesRequired:1];
    
    [btnVendorCheck addGestureRecognizer: TapRecognizerVendorCheck];
    btnVendorCheck.tag=1;
    
    UITapGestureRecognizer *TapRecognizerCoupleCheck = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (handleTapSelect:)];
    [TapRecognizerCoupleCheck setNumberOfTouchesRequired:1];

    [btnCoupleCheck addGestureRecognizer: TapRecognizerCoupleCheck];
    
    
    btnCoupleCheck.tag=2;
    
    [btnVendorCheck setImage:[UIImage imageNamed: @"check" ] forState:UIControlStateNormal];
    [btnCoupleCheck setImage:[UIImage imageNamed: @"uncheck"] forState:UIControlStateNormal];
    
   
    
    [self callGetLocation];
    [self callGetCategory];

    
      userType = @"Vendor";
    
    // Do any additional setup after loading the view.
}
- (void)handleTapSelect:(UITapGestureRecognizer *)sender
{
    
    if (sender.view.tag==1)
    {
        [btnVendorCheck setImage:[UIImage imageNamed: @"check" ] forState:UIControlStateNormal];
        [btnCoupleCheck setImage:[UIImage imageNamed: @"uncheck"] forState:UIControlStateNormal];
        
        
        constFacebookTop.constant=5.0;
        constFacebookHeight.constant=30.0;
        
        constTwitterTop.constant=15.0;
        constTwitterHeight.constant=30.0;
        
        constSnapchatTop.constant=15.0;
        constSnapchatHeight.constant=30.0;
        
        constInstaTop.constant=15.0;
        constInstaHeight.constant=30.0;
        
        constlblPriceTop.constant=15.0;
        constlblPriceHeight.constant=21.0;
        
        constCategoryTop.constant=15.0;
        constCategoryHeight.constant=30.0;
        
        constSliderHeight.constant=57.0;
        
        progressBarPriceRange.hidden=NO;
        constMaxPriceHeight.constant=30.0;
        
        constMinPriceTop.constant=15.0;
        constMaxPriceTop.constant=15.0;
        constMinPriceHeight.constant=30.0;
        
        
        userType = @"Vendor";
    }
    else
    {
        [btnVendorCheck setImage:[UIImage imageNamed: @"uncheck"] forState:UIControlStateNormal];
        [btnCoupleCheck setImage:[UIImage imageNamed: @"check"] forState:UIControlStateNormal];
        
        constFacebookTop.constant=0.0;
        constFacebookHeight.constant=0.0;
        
        constTwitterTop.constant=0.0;
        constTwitterHeight.constant=0.0;
        
        constSnapchatTop.constant=0.0;
        constSnapchatHeight.constant=0.0;
        
        constInstaTop.constant=0.0;
        constInstaHeight.constant=0.0;
        
        constlblPriceTop.constant=0.0;
        constlblPriceHeight.constant=0.0;
        
        constCategoryTop.constant=0.0;
        constCategoryHeight.constant=0.0;
        
        constSliderHeight.constant=0.0;
        
        progressBarPriceRange.hidden=YES;
        
        constMinPriceTop.constant=0.0;
        constMinPriceHeight.constant=0.0;
        
        constMaxPriceTop.constant=0.0;
        constMaxPriceHeight.constant=0.0;
        
        userType=@"Couple";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)TextfieldBoarder
{
    [AppUtilsShared setTextBoxBoarder:txtName];
    
    [AppUtilsShared setTextBoxBoarder:txtEmail];
    
    [AppUtilsShared setTextBoxBoarder:txtPassword];
    
    [AppUtilsShared setTextBoxBoarder:txtConfirmPassword];
    
    [AppUtilsShared setTextBoxBoarder:txtCategory];
    
    [AppUtilsShared setTextBoxBoarder:txtFacebook];
    
    [AppUtilsShared setTextBoxBoarder:txtInstagram];
    
    [AppUtilsShared setTextBoxBoarder:txtLocation];
    
    [AppUtilsShared setTextBoxBoarder:txtSnapChat];
    
    [AppUtilsShared setTextBoxBoarder:txtTwitter];
    [AppUtilsShared setTextBoxBoarder:txtMaxPrice];
    [AppUtilsShared setTextBoxBoarder:txtMinPrice];
   [AppUtilsShared setTextviewBoarder:tvShortBio];
    
    
    [AppUtilsShared setButtonRadius:btnCreateAccount];
    btnCreateAccount.layer.borderColor = [UIColor clearColor].CGColor;
    btnCreateAccount.layer.borderWidth =0.8;
    
 
   
   
    
    // range slider
    
    progressBarPriceRange.minLabelFont=[UIFont systemFontOfSize:10.0];
     progressBarPriceRange.maxLabelFont=[UIFont systemFontOfSize:10.0];
    progressBarPriceRange.delegate = self;
    progressBarPriceRange.minValue = 0;
    progressBarPriceRange.maxValue = 150;
    progressBarPriceRange.selectedMinimum = 0;
    progressBarPriceRange.selectedMaximum = 150;
    progressBarPriceRange.handleColor = [UIColor blueColor];
    progressBarPriceRange.handleDiameter = 10;
    progressBarPriceRange.selectedHandleDiameterMultiplier = 1.3;
    progressBarPriceRange.minLabelColour = [UIColor blackColor];
    progressBarPriceRange.maxLabelColour = [UIColor blackColor];
    progressBarPriceRange.tintColor = AppColor;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    progressBarPriceRange.numberFormatterOverride = formatter;
    

    [AppUtilsShared setPlaceHolderViewImage:txtFacebook :@"Facebook":@"Left"];
      [AppUtilsShared setPlaceHolderViewImage:txtTwitter :@"Twitter":@"Left"];
      [AppUtilsShared setPlaceHolderViewImage:txtSnapChat :@"Snapchat":@"Left"];
      [AppUtilsShared setPlaceHolderViewImage:txtInstagram :@"Instagram":@"Left"];
    
     [AppUtilsShared setPlaceHolderViewImage:txtCategory :@"downArrow":@"Right"];
    
    
    
}
- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
    
}
#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
       // NSLog(@"Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
    
 
}

- (void)btnSignInClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)setProgress:(float)progress animated:(BOOL)animated NS_AVAILABLE_IOS(5_0);
{

}
#pragma mark -UITableViewDataSource
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView*)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(arrLocation.count>0)
    {
        return arrLocation.count;
    }
    else
    {
        tblLocation.hidden=YES;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    if(arrLocation.count>0)
    {
    static NSString* cellIdentifier = @"Cell";
    
    
    cell = (UITableViewCell*)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        
        //cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines=2;
          }
       
    cell.textLabel.text=[[arrLocation objectAtIndex:indexPath.row] valueForKey:@"locationName"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    
    }
    else
    {
        tblLocation.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    txtLocation.text=[[arrLocation objectAtIndex:indexPath.row] valueForKey:@"locationName"];
    tblLocation.hidden=YES;
        NSString *searchTerm =txtLocation.text;
    
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationName = %@", searchTerm];
            stLocationId = [[[arrLocation filteredArrayUsingPredicate:predicate] valueForKey:@"LocationId"] objectAtIndex:0];
    [txtLocation resignFirstResponder];
    

}
#pragma mark - TextField Delegate Methods
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    tblLocation.hidden=YES;
    
    if (textField==txtCategory) {
        [self.view endEditing:YES];
        txtCategory.tag=1;
        txtLocation.tag=0;
        DashboardPopUp
        *objDashboardPopUp = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardPopUp"];
        objDashboardPopUp.delegate = self;
        
        long height = arrCategory.count * 44;
        if (height > 200) {
            height = 200;
        }
        objDashboardPopUp.navigationController.navigationBarHidden = YES;
        
        objDashboardPopUp.arrData = [arrCategory valueForKey:@"Name"];
        
        popoverController = [[WYPopoverController alloc] initWithContentViewController:objDashboardPopUp];
        popoverController.delegate = self;
        // strPopupName=@"AddProfile";
        
        objDashboardPopUp.preferredContentSize = CGSizeMake(200, height);
        
        [popoverController presentPopoverFromRect:txtCategory.bounds inView:txtCategory permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        
        return NO;

    }
    if (textField==txtLocation)
    {
//        tblLocation.hidden=NO;
         tblLocation=[[UITableView alloc]initWithFrame: CGRectMake(20, txtLocation.frame.origin.y+txtLocation.frame.size.height, self.view.bounds.size.width-24, ScrollView.bounds.size.height/3-30)];
        tblLocation.delegate=self;
        tblLocation.dataSource=self;
        tblLocation.layer.borderColor = [UIColor darkGrayColor].CGColor;
        tblLocation.layer.backgroundColor=[UIColor whiteColor].CGColor;
        tblLocation.layer.borderWidth=1.0f;
        [ScrollView addSubview:tblLocation];
        [tblLocation reloadData];
        return YES;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtLocation)
    {
    NSString *searchTerm=string;
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationName CONTAINS[c] %@", searchTerm];
        if([searchTerm length] > 0)
        {
            arrLocation = [[NSMutableArray alloc]initWithArray:[arrLocation filteredArrayUsingPredicate:predicate]];
        }
        else
        {
            arrLocation=[arrLoc mutableCopy];
        }
        
            [tblLocation reloadData];
          }
    return YES;
}

#pragma mark - TextView Delegate Methods
#pragma mark
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
        textView.text=@"";
    textView.textColor=[UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
   
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Short Bio";
            textView.textColor=[UIColor grayColor];
        }
        
       return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark DropDown Selected Method
-(void)SelectedValue :(NSString *)strValue
{
    [self dismisPopOver:nil];
    if(txtCategory.tag==1)
    {
    txtCategory.text=strValue;
    NSString *searchTerm =strValue;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name = %@", searchTerm];
    stCategoryId = [[[arrCategory filteredArrayUsingPredicate:predicate] valueForKey:@"CategoryId"] objectAtIndex:0];
    }
    }

- (void)dismisPopOver:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    
    if (![textField.text isEqualToString:@""]) {
        if(textField==txtLocation)
        {
            NSString *searchTerm =txtLocation.text;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationName = %@", searchTerm];
            
            if (arrLocation.count>0&&[arrLocation filteredArrayUsingPredicate:predicate].count>0) {
                stLocationId = [[[arrLocation filteredArrayUsingPredicate:predicate] valueForKey:@"LocationId"] objectAtIndex:0];
              
                
            }
            if([stLocationId isEqualToString:@""])
            {
                stLocationId=@"new";
                isopen = YES;
                stNewLocation=[NSString stringWithFormat:@"%@",txtLocation.text];
                
            }
            
            
        }
    }
    
    
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField==txtName)
    {
        [txtName resignFirstResponder];
        [txtEmail becomeFirstResponder];
        return NO;
    }
    else if (textField==txtEmail)
    {
        [txtEmail resignFirstResponder];
         [txtPassword becomeFirstResponder];
        return NO;
    }
    else if (textField==txtPassword)
    {
        [txtPassword resignFirstResponder];
        [txtConfirmPassword becomeFirstResponder];
        return NO;
    }
    else if (textField==txtConfirmPassword)
    {
        [txtConfirmPassword resignFirstResponder];
        
        return NO;
        
    }
    else if (textField==txtLocation)
    {
        [txtLocation resignFirstResponder];
        [txtMinPrice becomeFirstResponder];
        return NO;
        
    }
    else if (textField == txtMinPrice)
    {
        [txtMinPrice resignFirstResponder];
        [txtMaxPrice becomeFirstResponder];
        return NO;
    }
    else if (textField == txtMaxPrice)
    {
        [txtMaxPrice resignFirstResponder];
        [txtFacebook becomeFirstResponder];
        return NO;
    }
    else if (textField==txtFacebook)
    {
        [txtFacebook resignFirstResponder];
        [txtTwitter becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtTwitter)
    {
        [txtTwitter resignFirstResponder];
        [txtSnapChat becomeFirstResponder];

        
        return NO;
        
    }
    else if (textField==txtSnapChat)
    {
        [txtSnapChat resignFirstResponder];
        [txtInstagram becomeFirstResponder];
        return NO;
        
    }
    
    else{
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)callGetCategory
{
    [WebServiceCall getRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/GetCategories" showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            arrCategory = [[response valueForKey:@"message"] mutableCopy];
            stCategoryId=[[[response valueForKey:@"message"]objectAtIndex:0] valueForKey:@"CategoryId"];
            txtCategory.text=[[[response valueForKey:@"message"]objectAtIndex:0] valueForKey:@"Name"];
        }
    }];
    
}

-(void)callGetLocation
{
    [WebServiceCall getRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/GetLocation" showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            arrLocation = [[response valueForKey:@"message"] mutableCopy];
            for (int i=0; i<arrLocation.count; i++) {
                if (![[[arrLocation objectAtIndex:i]valueForKey:@"locationName"] isKindOfClass:[NSNull class]] && ![[[arrLocation objectAtIndex:i]valueForKey:@"LocationId"] isKindOfClass:[NSNull class]]) {
                    
                    [arrLoc addObject:[arrLocation objectAtIndex:i]];
                    
                }
            }
            arrLocation = [arrLoc mutableCopy];
            
        }
    }];
    
}

-(void)callRegistrationService
{
    if([self validation])
    {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%@",txtName.text],@"name",                                                                                        [NSString stringWithFormat:@"%@",txtEmail.text],@"email",
                           [NSString stringWithFormat:@"%@",txtPassword.text],@"password",
                           [NSString stringWithFormat:@"%@",userType],@"usertype",
                          [NSString stringWithFormat:@"%@",stLocationId],@"location",
                          [NSString stringWithFormat:@"%@",tvShortBio.text],@"shortbio",
                          [NSString stringWithFormat:@"%@",txtFacebook.text],@"facebook",
                          [NSString stringWithFormat:@"%@",txtTwitter.text],@"twitter",
                          [NSString stringWithFormat:@"%@",txtSnapChat.text],@"snapchat",
                          [NSString stringWithFormat:@"%@",txtInstagram.text],@"instagram",
                          [NSString stringWithFormat:@"%@",stCategoryId],@"catgegory_id",
                          [NSString stringWithFormat:@"%@",txtMinPrice.text],@"minprice",
                          [NSString stringWithFormat:@"%@",txtMaxPrice.text],@"maxprice",
                          @"",@"image",
                          @"",@"phone",
                          @"",@"mobileno",
                          [NSString stringWithFormat:@"%@",stNewLocation],@"new_loc",
                          @"N",@"is_update",
                          nil];
    
    // DELEGATE.statusLoad = @"Getting Courses...";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];

    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Register" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            NSLog(@"Response%@",response);
            [AppUtilsShared ShowNotificationwithMessage:[response valueForKey:@"message"] withcolor:SUCCESSCOLOR];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    }
}
-(BOOL)validation
{
    if([txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Name." withcolor:REDCOLOR];
        return NO;
    }
    else if([txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0 || ![AppUtilsShared validateEmailWithString:txtEmail.text])
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Valid EMail." withcolor:REDCOLOR];
        return NO;
    }
    else if([txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Password." withcolor:REDCOLOR];
        return NO;
    }
    else if(txtPassword.text.length<4 && txtPassword.text.length>10)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Password should be between 4 and 10." withcolor:REDCOLOR];
        return NO;
    }
    else if ([txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Confirm Password." withcolor:REDCOLOR];
        return NO;
    }
    else if(![txtPassword.text isEqualToString:txtConfirmPassword.text])
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Password and confirm password must match." withcolor:REDCOLOR];
        return NO;
    }
    
    
    else if([txtLocation.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Location." withcolor:REDCOLOR];
        return NO;
    }
    if([userType isEqualToString:@"Vendor"])
    {
        if([txtCategory.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
        {
            [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Category." withcolor:REDCOLOR];
            return NO;
        }
        
        else if ([txtMinPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
        {
            [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Minimum Price." withcolor:REDCOLOR];
            return NO;
        }
        else if ([txtMaxPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
        {
            [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Maximum Price." withcolor:REDCOLOR];
            return NO;
        }
        else if ([txtMinPrice.text integerValue] > [txtMaxPrice.text integerValue])
        {
            [AppUtilsShared ShowNotificationwithMessage:@"Maximum price must not be less than minimum price" withcolor:REDCOLOR];
            return NO;
        }
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

- (IBAction)btnCreateAccountClick:(id)sender
{
    [self.view endEditing:YES];
    [self callRegistrationService];
}
@end
