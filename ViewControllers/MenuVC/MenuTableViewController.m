//
//  MenuTableViewController.m
//  LittleStarAdmin
//
//  Created by Kunj Patel on 9/28/15.
//  Copyright © 2015 Openxcell Technolabs. All rights reserved.
//

#import "MenuTableViewController.h"
#import "AppUtils.h"
#import "RootNavigationController.h"
#import "DashboardViewController.h"
#import "QMApi.h"
#import "QMDialogsViewController.h"
#import "launchScreenViewController.h"
#define BUFFERX 20 //distance from side to the card (higher makes thinner card)
#define BUFFERY 40 //distance from top to the card (higher makes shorter card)


@implementation MenuTableViewController

{
    NSMutableArray *arrImagesGray;
    NSArray *arrImagesSelected;
    NSMutableArray *arrNames;
    
    RootNavigationController *navigationController;
    UILabel *lblName;
    UILabel *lblMsgCount;
}


@synthesize arrImagesGray,arrNames;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
       self.tableView.backgroundColor = [UIColor blackColor];
    
        
    
    UIButton *btnFacebook=[[UIButton alloc] initWithFrame:CGRectMake(20, self.tableView.frame.size.height-40, 25, 25)];
    [btnFacebook setImage:[UIImage imageNamed:@"Menu-Facebook"] forState:UIControlStateNormal];
   // [self.tableView addSubview:btnFacebook];
    
    UIButton *btnTwitter=[[UIButton alloc] initWithFrame:CGRectMake(btnFacebook.frame.size.width+30,self.tableView.frame.size.height-40 , 25, 25)];
    [btnTwitter setImage:[UIImage imageNamed:@"Menu-Twitter"] forState:UIControlStateNormal];
  //  [self.tableView addSubview:btnTwitter];
    
    UIButton *btnInsta=[[UIButton alloc] initWithFrame:CGRectMake(btnFacebook.frame.size.width+btnTwitter.frame.size.width+40, self.tableView.frame.size.height-40, 25, 25)];
    [btnInsta setImage:[UIImage imageNamed:@"Menu-Instagram"] forState:UIControlStateNormal];
    
  //  [self.tableView addSubview:btnInsta];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[AppUtilsShared getPreferences:@"autoLogin"] isEqualToString:@"YES"])
    {
        arrImagesGray = [[NSMutableArray alloc] initWithObjects:@"MyProfile",@"Messages",@"Browse",@"Logout",nil];
        
        
        arrNames = [[NSMutableArray alloc]initWithObjects:@"My Profile",@"Messages",@"Browse",@"Logout",nil];
    }
    else
    {
        arrImagesGray = [[NSMutableArray alloc] initWithObjects:@"MyProfile",@"Messages",@"Browse",@"Logout",nil];
        
        
        arrNames = [[NSMutableArray alloc]initWithObjects:@"My Profile",@"Messages",@"Browse",@"Sign In",nil];
        
    }
    [self.tableView reloadData];
}



#pragma mark
#pragma mark - TableView Method
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, cellHeader.frame.size.height-2, tableView.frame.size.width-20, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:129.0/255.0 green:21.0/255.0 blue:95.0/255.0 alpha:0.5].CGColor;
    separatorView.layer.borderWidth = 1.0;
    [cellHeader.contentView addSubview:separatorView];
    cellHeader.backgroundColor = AppColor;
    return cellHeader;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifire = @"CellMenu";
    UITableViewCell *cell = (UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    lblName = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, tableView.bounds.size.width,20)];
    UIButton *imgViewLogo = (UIButton *)[cell viewWithTag:1];
    
    lblName = (UILabel *)[cell viewWithTag:2];
    
    
    
    lblName.text = [arrNames objectAtIndex:indexPath.row];
    
    
    
    imgViewLogo.layer.cornerRadius = 0.0;
    imgViewLogo.layer.masksToBounds=YES;
    [imgViewLogo setImage:[UIImage imageNamed:[arrImagesGray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    
    lblName.textColor = [UIColor whiteColor];
    
    
   cell.backgroundColor=[UIColor blackColor];
    
    if(indexPath.row==1)
        
    {
        lblMsgCount = [[UILabel alloc]init];
        lblMsgCount.frame = CGRectMake(cell.frame.size.width-40, 5, 30, 30);
        lblMsgCount.backgroundColor = AppColor;
        
        lblMsgCount.layer.cornerRadius = lblMsgCount.frame.size.height/2;
        lblMsgCount.layer.borderColor=[UIColor blackColor].CGColor;
        lblMsgCount.clipsToBounds=YES;
        lblMsgCount.backgroundColor=[UIColor blackColor];
        
        lblMsgCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)2];
        lblMsgCount.textColor = [UIColor whiteColor];
        //[cell addSubview:lblMsgCount];
        
        
    }
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-2, tableView.frame.size.width-20, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:129.0/255.0 green:21.0/255.0 blue:95.0/255.0 alpha:0.5].CGColor;
    separatorView.layer.borderWidth = 1.0;
    //[cell.contentView addSubview:separatorView];
    
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[arrNames objectAtIndex:indexPath.row] isEqualToString:@"Browse"])
    {
        DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        objDashboardViewController.stTitle = [arrNames objectAtIndex:indexPath.row];
        navigationController.viewControllers = @[objDashboardViewController];
        self.frostedViewController.contentViewController = navigationController;
        
        [self.frostedViewController hideMenuViewController];
        
    }
    else  if ([[arrNames objectAtIndex:indexPath.row] isEqualToString:@"Sign In"])
    {
        LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        objLoginViewController.stTitle = [arrNames objectAtIndex:indexPath.row];
        navigationController.viewControllers = @[objLoginViewController];
        self.frostedViewController.contentViewController = navigationController;
        
        [self.frostedViewController hideMenuViewController];
        
    }
    else  if ([[arrNames objectAtIndex:indexPath.row] isEqualToString:@"My Profile"])
    {
        if([[AppUtilsShared getPreferences:@"autoLogin"] isEqualToString:@"YES"])
        {
            MyProfileViewController *objMyProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            
            navigationController.viewControllers = @[objMyProfileViewController];
            //  [navigationController pushViewController:objMyProfileViewController animated:YES];
        }
        else
        {
            LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            objLoginViewController.stTitle = [arrNames objectAtIndex:indexPath.row];
            navigationController.viewControllers = @[objLoginViewController];
        }
        self.frostedViewController.contentViewController = navigationController;
        
        [self.frostedViewController hideMenuViewController];
    }
    else if ([[arrNames objectAtIndex:indexPath.row] isEqualToString:@"Messages"]){
         Delegate.isFromChatList=YES;
        
       /* [SVProgressHUD show];
        NSString *QuickEmail = [NSString stringWithFormat:@"%@",[AppUtilsShared getPreferences:@"Emailid"]];
        
        [[QMApi instance] loginWithEmail:QuickEmail password:@"admin@123" rememberMe:YES completion:^(BOOL success) {
            if (success) {
                */
        
        if([[AppUtilsShared getPreferences:@"autoLogin"] isEqualToString:@"YES"])
        {
            [SVProgressHUD show];
            
            NSArray* tempVCA = [navigationController viewControllers];
            
            for(UIViewController *tempVC in tempVCA)
            {
                if([tempVC isKindOfClass:[launchScreenViewController class]])
                {
                    [tempVC removeFromParentViewController];
                }
            }
            
            [self connectToChat];
        }
        else
        {
            LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            //objLoginViewController.stTitle = [arrNames objectAtIndex:indexPath.row];
            navigationController.viewControllers = @[objLoginViewController];
            
            self.frostedViewController.contentViewController = navigationController;
            
            [self.frostedViewController hideMenuViewController];
        }

      
                
           /* }
            else{
                
            
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Chat details not found!"
                                          message:nil
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                });
            }
        }];
        */
        
        
        
        
        
    }
    else if ([[arrNames objectAtIndex:indexPath.row] isEqualToString:@"Logout"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout" message:@"Are you sure you want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self closeAlertview];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self ok];
        }]];
        
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        return;
    }
   
    
}







-(void)closeAlertview
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)ok
{
    [AppUtilsShared setPreferences:nil withKey:@"MemberId"];
    
    [AppUtilsShared setPreferences:nil withKey:@"LocationId"];
    
    [AppUtilsShared setPreferences:nil withKey:@"VenderId"];
    
    [AppUtilsShared setPreferences:nil withKey:@"Password"];
    
    [AppUtilsShared setPreferences:@"NO" withKey:@"autoLogin"];
    
    [AppUtilsShared clearAllPrefrences];
    DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    //objDashboardViewController.stTitle = [arrNames objectAtIndex:indexPath.row];
    navigationController.viewControllers = @[objDashboardViewController];
    
    if ([QMApi instance].currentUser) {
        
        [[QMApi instance] logoutWithCompletion:^(BOOL success) {
            //
            NSLog(@"test");
        }];
    }
    self.frostedViewController.contentViewController = navigationController;
    
    [self.frostedViewController hideMenuViewController];

    
    
}
- (void)connectToChat
{
//    
//    [[QMApi instance] loginWithEmail:[AppUtilsShared getPreferences:@"Emailid"] password:@"admin@123" rememberMe:YES completion:^(BOOL success)
//   {
//       if (success)
//       {
//    
    
    [[QMApi instance] connectChat:^(BOOL loginSuccess) {
        if (loginSuccess) {
            QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
            
            [QBRequest dialogsForPage:page extendedRequest:nil successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
                
                // appDelegate.loadAllChat = YES;
                
                // for (int f=0; f<dialogObjects.count; f++) {
                
                NSLog(@"%@",dialogObjects);
                Delegate.isFromChatList=YES;
                
                
                // if(btnQuickBloxMsgRef.tag==1)
                // {
                UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                
                QMDialogsViewController *demoViewController = [objStoryboard  instantiateViewControllerWithIdentifier:@"QMDialogsViewController"];
                
                //[navigationController pushViewController:demoViewController animated:YES];
                [SVProgressHUD dismiss];
                
                self.frostedViewController.contentViewController = navigationController;
                
                [self.frostedViewController hideMenuViewController];
                navigationController.viewControllers = @[demoViewController];
                /*  }
                 else
                 {
                 
                 if (dialogObjects.count>0) {
                 long UnreadCount=0;
                 for (int f=0; f<dialogObjects.count; f++) {
                 UnreadCount=UnreadCount+[[[dialogObjects objectAtIndex:f]valueForKey:@"unreadMessagesCount"]longValue];
                 }
                 NSString *strUnreadCount=[NSString stringWithFormat:@"%ld",UnreadCount];
                 if(![strUnreadCount isEqualToString:@"0"])
                 {
                 lblAlertCount.backgroundColor = [AppUtilsShared getColor:ApplicationColor];
                 
                 lblAlertCount.layer.cornerRadius = lblAlertCount.frame.size.height/2;
                 lblAlertCount.clipsToBounds=YES;
                 
                 
                 lblAlertCount.text = [NSString stringWithFormat:@"%@",strUnreadCount];
                 
                 
                 constWidthQuickMsgCount.constant = lblAlertCount.text.length*20;
                 
                 }
                 
                 }
                 
                 }*/
                
                
                return ;
                //  }
                
            } errorBlock:^(QBResponse *response) {
                [SVProgressHUD dismiss];
            }];

        }
        else{
            
            [AppUtilsShared ShowNotificationwithMessage:@"Something went wrong" withcolor:REDCOLOR];
            [SVProgressHUD dismiss];
        }
           }];
//       }
//       else
//       {
//           [AppUtilsShared ShowNotificationwithMessage:@"Something went wrong" withcolor:REDCOLOR];
//           [SVProgressHUD dismiss];
//       }
//
//   }];
}

@end
