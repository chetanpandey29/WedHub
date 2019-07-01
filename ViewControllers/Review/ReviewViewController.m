//
//  ReviewViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 12/01/17.
//  Copyright © 2017 Flexi_Mac2. All rights reserved.
//

#import "ReviewViewController.h"
#import "LoginViewController.h"
@interface ReviewViewController ()
{
    UIButton *btnTransperencyButton;
}
@end

@implementation ReviewViewController
@synthesize arrReview,vwRating,vwReview,lblReview,tvComments,tblReview,btnSubmit,btnReview,strCategoryId,strUserType,lblCommentPlace;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"REVIEW"];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    vwReview.hidden=YES;
    lblReview.backgroundColor=AppColor;
    lblReview.textColor=[UIColor whiteColor];
    
    
    vwRating.backgroundColor  = [UIColor whiteColor];
    vwRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vwRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vwRating.maxRating = 5.0;
    vwRating.delegate = self;
    vwRating.editable=YES;
    vwRating.rating=1.0;
    vwRating.tintColor = [UIColor colorWithRed:222.0/255.0 green:140.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    vwRating.displayMode=EDStarRatingDisplayHalf;
   
    btnReview.layer.cornerRadius=btnReview.frame.size.height/2;
    btnReview.backgroundColor=AppColor;
    lblCommentPlace.hidden=NO;
    [btnSubmit setTitleColor:AppColor forState:UIControlStateNormal];
    [AppUtilsShared setTextviewBoarder:tvComments];
    
    [self callGetRevies];
    

}
-(void)dismissHelper:(id)sender
{
    vwReview.hidden=YES;
    btnTransperencyButton.hidden=YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrReview.count>0)
    {
        return arrReview.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:1];
    if(![[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Image"] isKindOfClass:[NSNull class]] && ![[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Image"] isEqualToString:@""])
    {
        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Image"] ];
        [img sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
    }
    else
    {
        img.image = [UIImage imageNamed:@"placeholder_image"];
    }
    img.layer.cornerRadius = img.frame.size.height/2;
    img.clipsToBounds = YES;
    
    EDStarRating *ratingView = (EDStarRating *)[cell viewWithTag:2];
    ratingView.backgroundColor  = [UIColor whiteColor];
    ratingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.maxRating = 5.0;
    ratingView.delegate = self;
    ratingView.rating=[[NSString stringWithFormat:@"%@",[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Rating"]] floatValue];
    ratingView.tintColor = [UIColor colorWithRed:222.0/255.0 green:140.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    ratingView.displayMode=EDStarRatingDisplayHalf;
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:3];
    lblName.text=[NSString stringWithFormat:@"%@",[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Name"]];
    
    UILabel *lblDescription =(UILabel *)[cell viewWithTag:4];
    
    lblDescription.text=[NSString stringWithFormat:@"%@",[[arrReview objectAtIndex:indexPath.row] valueForKey:@"Comment"]];
    
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (IBAction)btnFeedback:(id)sender {
    if([[AppUtilsShared getPreferences:@"autoLogin"] isEqualToString:@"YES"])
    {
        
      
        
        if([[AppUtilsShared getPreferences:@"UserType"] isEqualToString:@"Vendor"])
        {
            [AppUtilsShared ShowNotificationwithMessage:@"Vendor cannot review vendor." withcolor:REDCOLOR];
        }
        else
        {
              vwReview.hidden=NO;
            btnTransperencyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
            btnTransperencyButton.backgroundColor = [UIColor blackColor];
            btnTransperencyButton.alpha=0.6;
            [btnTransperencyButton addTarget:self action:@selector(dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
            [self.view insertSubview:btnTransperencyButton belowSubview:vwReview];
            
        }

    }
    else
    {
        LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        objLoginViewController.isReview=YES;   //If From Review
        [self.navigationController pushViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     :objLoginViewController animated:YES];
    }
}
- (IBAction)btnSubmit:(id)sender {
    
    [self callSaveFeedback];
}
-(void)callSaveFeedback
{
    lblCommentPlace.hidden=YES;
    if([tvComments.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [AppUtilsShared getPreferences:@"MemberId"],@"MemberId",
                              [AppUtilsShared getPreferences:@"VenderId"],@"VenderId",
                              [AppUtilsShared getPreferences:@"VendorCategoryId"],@"CategoryId",
                              [NSString stringWithFormat:@"%f",vwRating.rating],@"Rating",
                              tvComments.text,@"Comment",
                              nil];

        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        
        
        
        [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/saveReview" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
            if (Success) {
                NSLog(@"Response%@",response);
                [self callGetRevies];
                vwReview.hidden=YES;
                btnTransperencyButton.hidden=YES;
                
            }
        }];
        
    }
    else
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please write review..." withcolor:REDCOLOR];
    }
    
}
-(void)callGetRevies
{
    [WebServiceCall getRequestWithUrl:[NSString stringWithFormat:@"%@GeneralWedHub/GetVenderDetail?VenderId=%@",WEBSERVICEURL,[AppUtilsShared getPreferences:@"VenderId"]] showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            arrReview=[[[response valueForKey:@"message"] valueForKey:@"dt_ReturnedTables"]valueForKey:@"review"];
            [tblReview reloadData];
        }
    }];
    
}
#pragma mark - TextView Delegate Methods
#pragma mark
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    lblCommentPlace.hidden=YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if([textView.text isEqualToString:@""])
    {
        lblCommentPlace.hidden=NO;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
