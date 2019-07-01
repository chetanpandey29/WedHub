//
//  QMCreateNewChatController.m
//  Q-municate
//
//  Created by Igor Alefirenko on 31/03/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMCreateNewChatController.h"
#import "QMViewControllersFactory.h"
#import "SVProgressHUD.h"
#import "QMApi.h"
#import "QMUsersUtils.h"
#import "QMInviteFriendCell.h"
#import "QMChatVC.h"

NSString *const QMChatViewControllerID = @"QMChatVC";

@implementation QMCreateNewChatController
{
    NSMutableArray *allUserArray;
    //SyncViewController *syncObj;
    NSMutableArray *selectedBlobidArray;
    
    NSMutableArray *arrSection;
    
    
}



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    
    
    //syncObj = [[SyncViewController alloc]init];
    allUserArray = [[NSMutableArray alloc]init];
    selectedBlobidArray = [[NSMutableArray alloc]init];
    
    [_createchat setEnabled:NO];
    
    //allUserArray = [syncObj GEtAlluserData_forQuickBlox];
    
    //for index and section
    if (allUserArray!=nil && allUserArray.count>0) {
        
        arrSection = [allUserArray valueForKey:@"RepName"];
        
        arrSection=[[[NSOrderedSet orderedSetWithArray:arrSection] array] mutableCopy];
        
        arrSection=[self indexLettersForStrings:arrSection];
        
        
        
        for (int g=0; g<arrSection.count; g++) {
            
            [arrSection replaceObjectAtIndex:g withObject:[[arrSection objectAtIndex:g] uppercaseString]];
            
            
        }
        
        arrSection=[[[NSOrderedSet orderedSetWithArray:arrSection] array] mutableCopy];
        
        arrSection = [[arrSection sortedArrayUsingSelector:
                       @selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    }
    
    
    //top user detail view
    [self ConfigureTopUserView];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)ConfigureTopUserView {
    
    self.lblName.text=[self.dicCustomerData valueForKey:@"CustomerName"];
    self.lblName1.text=[self.dicCustomerData valueForKey:@"Address"];
    self.lblName2.text=[self.dicCustomerData valueForKey:@"Zip"];
    if ([_dicCustomerData valueForKey:@"Mile"]==nil) {
        [_dicCustomerData setValue:@"-" forKey:@"Mile"];
        
    }

    self.lblMile.text=[self.dicCustomerData valueForKey:@"Mile"];
    
}

#pragma mark - Overriden Actions

- (IBAction)performAction:(id)sender {
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"RepName beginswith[c] %@", [arrSection objectAtIndex:section]];
    
    NSArray *filteredArr = [allUserArray filteredArrayUsingPredicate:pred];
    
    return filteredArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return arrSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QMInviteFriendCell *dcell = [tableView dequeueReusableCellWithIdentifier:@"CreateChatCell"];
    
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"RepName beginswith[c] %@", [arrSection objectAtIndex:indexPath.section]];
    
    NSArray *filteredArr = [allUserArray filteredArrayUsingPredicate:pred];
    
    
    dcell.titleLabel.text= [[filteredArr objectAtIndex:indexPath.row] valueForKey:@"RepName"];
    
    //User image
    UIImage *img = [UIImage imageNamed:@"placeholder_single"];
    
    dcell.qmImageView.imageViewType = QMImageViewTypeCircle;
    
    [dcell.qmImageView setImageWithURL:[NSURL URLWithString:@"Need to pass user avatar URL here"] placeholder:img options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    
    if ([selectedBlobidArray containsObject:[[filteredArr objectAtIndex:indexPath.row]valueForKey:@"BlobId"]]) {
        
        [dcell.activeCheckBox setHidden:NO];
        [dcell.activeunCheckBox setHidden:YES];
        
    }
    else{
        
        [dcell.activeCheckBox setHidden:YES];
        [dcell.activeunCheckBox setHidden:NO];
        
    }
    
    dcell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    tableView.sectionIndexColor = [UIColor darkGrayColor];
    tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    
    
    return dcell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QMInviteFriendCell *didcell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"RepName beginswith[c] %@", [arrSection objectAtIndex:indexPath.section]];
    NSArray *filteredArr = [allUserArray filteredArrayUsingPredicate:pred];
    
    if ([selectedBlobidArray containsObject:[[filteredArr objectAtIndex:indexPath.row]valueForKey:@"BlobId"]]) {
        
        [didcell.activeCheckBox setHidden:YES];
        [didcell.activeunCheckBox setHidden:NO];
        
        [selectedBlobidArray removeObject:[[filteredArr objectAtIndex:indexPath.row]valueForKey:@"BlobId"]];
        
    }
    else{
        
        [didcell.activeCheckBox setHidden:NO];
        [didcell.activeunCheckBox setHidden:YES];
        
        [selectedBlobidArray addObject:[[filteredArr objectAtIndex:indexPath.row]valueForKey:@"BlobId"]];
        
    }
    
    
    if (selectedBlobidArray.count>0) {
        [_createchat setEnabled:YES];
        
    }
    else{
        [_createchat setEnabled:NO];
    }
    
    self.lblselect.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedBlobidArray.count];
    [tableView reloadData];
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    viewHeader.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 30)];
    
    
    lbl.font=[UIFont systemFontOfSize:17];
    
    lbl.text=[[arrSection objectAtIndex:section] uppercaseString];
    
    [viewHeader addSubview:lbl];
    
    return viewHeader;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [arrSection objectAtIndex:section];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
    
}

- (NSArray *)cellIndexTitlesForTableView:(UITableView *)tableView
{
    
    return arrSection ;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arrSection;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [arrSection indexOfObject:title];
}


- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)createChat:(id)sender
{
    
    NSMutableArray *selectedUsersMArray = self.selectedFriends;
    
    
    
//    QMChatVC *chatController = segue.destinationViewController;
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    QBChatDialog *dialog = [self.dataSource dialogAtIndexPath:indexPath];
//    chatController.dialog = dialog;
//    chatController.dicCustomerData=self.dicCustomerData;
    
    
    if (selectedBlobidArray.count==1) {
        
        

        
        QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
        
        [QBRequest dialogsForPage:page extendedRequest:nil successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
            
           
                
                for (int f=0; f<dialogObjects.count; f++) {
                    
                    
                    NSMutableArray *arrtemp = [[dialogObjects objectAtIndex:f] valueForKey:@"occupantIDs"];
                    
                    NSString *str = [NSString stringWithFormat:@"%@",[selectedBlobidArray objectAtIndex:0]];
                    
         
                    
                    
                    if ([arrtemp containsObject:[NSNumber numberWithInteger: [str integerValue]]]&&arrtemp.count==2) {
                        
                        if ([[_dicCustomerData valueForKey:@"CustomerID"]isEqualToString:[[[dialogObjects objectAtIndex:f] valueForKey:@"data"]valueForKey:@"LevelID"]]) {
                            
                            
                            QBChatDialog *dialog = dialogObjects[f];
                            
                             UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                            
                            QMChatVC *objChat = [objStoryboard instantiateViewControllerWithIdentifier:@"QMChatVC"];
                            
                            
                        objChat.dialog = dialog;
                        objChat.dicCustomerData=self.dicCustomerData;
                          
                            
                            
                            
                            [self.navigationController pushViewController:objChat animated:YES];
                            
                            
                            return ;
                            
                        }
                        
                        
                   
                    }
                    
                    
                  
                    
                }
                [SVProgressHUD dismiss];
                
                
                
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                
                
                
                __weak __typeof(self)weakSelf = self;
                
                
                __block    NSString *chatName;
                
                [QBRequest usersWithIDs:selectedBlobidArray page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                    
                    
                    chatName = [self chatNameFromUserNames:users];
                    
                    
                    
                    
                    chatName.accessibilityHint=[_dicCustomerData valueForKey:@"CustomerID"];
                    
                    
                    chatName.accessibilityElements = [[NSMutableArray alloc]initWithObjects:[_dicCustomerData valueForKey:@"CustomerName"],[_dicCustomerData valueForKey:@"Address"],[_dicCustomerData valueForKey:@"Zip"],[_dicCustomerData valueForKey:@"Mile"],[_dicCustomerData valueForKey:@"Type"], nil];
                    
                    [[QMApi instance] createGroupChatDialogWithName:chatName occupants:selectedBlobidArray completion:^(QBChatDialog *chatDialog) {
                        
                        
                        
                        if (chatDialog != nil) {
                            
                            chatDialog.ID.accessibilityElements= self.dicCustomerData;//comment
                            
                            UIViewController *chatVC = [QMViewControllersFactory chatControllerWithDialogID:chatDialog.ID];
                            
                            
                            
                            NSMutableArray *controllers = weakSelf.navigationController.viewControllers.mutableCopy;
                            
                            [controllers removeLastObject];
                            
                            [controllers addObject:chatVC];
                            
                            
                            
                            [weakSelf.navigationController setViewControllers:controllers animated:YES];
                            
                        }
                        
                        
                        
                        [SVProgressHUD dismiss];
                        
                    }];
                    
                    
                    
                    // Successful response with page information and users array
                } errorBlock:^(QBResponse *response) {
                    // Handle error here
                }];
                

                
                
                
            
            
            
        } errorBlock:^(QBResponse *response) {
            [SVProgressHUD dismiss];
        }];
        
        
     
  
        
     
        
        
    }
    else{
        
        UIAlertView *altGroup = [[UIAlertView alloc]initWithTitle:nil message:@"Enter group name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        altGroup.tag=999;
        altGroup.delegate=self;
        altGroup.alertViewStyle=UIAlertViewStylePlainTextInput;
        [altGroup show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        if (selectedBlobidArray.count>0)
        {
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
            
            
            __weak __typeof(self)weakSelf = self;
            
           __block NSString *chatName;
            
            if ([[[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length]>0) {
                  chatName = [alertView textFieldAtIndex:0].text;
                
                chatName.accessibilityHint=[_dicCustomerData valueForKey:@"CustomerID"];
                chatName.accessibilityElements = [[NSMutableArray alloc]initWithObjects:[_dicCustomerData valueForKey:@"CustomerName"],[_dicCustomerData valueForKey:@"Address"],[_dicCustomerData valueForKey:@"Zip"],[_dicCustomerData valueForKey:@"Mile"],[_dicCustomerData valueForKey:@"Type"], nil];
                
                
                
                
                
                
                
                [[QMApi instance] createGroupChatDialogWithName:chatName occupants:selectedBlobidArray completion:^(QBChatDialog *chatDialog) {
                    
                    
                    
                    if (chatDialog != nil) {
                        
                        chatDialog.ID.accessibilityElements= self.dicCustomerData;//comment
                        
                        UIViewController *chatVC = [QMViewControllersFactory chatControllerWithDialogID:chatDialog.ID];
                        
                        
                        
                        NSMutableArray *controllers = weakSelf.navigationController.viewControllers.mutableCopy;
                        
                        [controllers removeLastObject];
                        
                        [controllers addObject:chatVC];
                        
                        
                        
                        [weakSelf.navigationController setViewControllers:controllers animated:YES];
                        
                    }
                    
                    
                    
                    [SVProgressHUD dismiss];
                    
                }];
            }
            else{
                
                [QBRequest usersWithIDs:selectedBlobidArray page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                    
                    
                    chatName = [self chatNameFromUserNames:users];
                    
                    
                    chatName.accessibilityHint=[_dicCustomerData valueForKey:@"CustomerID"];
                    chatName.accessibilityElements = [[NSMutableArray alloc]initWithObjects:[_dicCustomerData valueForKey:@"CustomerName"],[_dicCustomerData valueForKey:@"Address"],[_dicCustomerData valueForKey:@"Zip"],[_dicCustomerData valueForKey:@"Mile"],[_dicCustomerData valueForKey:@"Type"], nil];
                    
                    
                    
                    
                    
                    
                    
                    [[QMApi instance] createGroupChatDialogWithName:chatName occupants:selectedBlobidArray completion:^(QBChatDialog *chatDialog) {
                        
                        
                        
                        if (chatDialog != nil) {
                            
                            chatDialog.ID.accessibilityElements= self.dicCustomerData;//comment
                            
                            UIViewController *chatVC = [QMViewControllersFactory chatControllerWithDialogID:chatDialog.ID];
                            
                            
                            
                            NSMutableArray *controllers = weakSelf.navigationController.viewControllers.mutableCopy;
                            
                            [controllers removeLastObject];
                            
                            [controllers addObject:chatVC];
                            
                            
                            
                            [weakSelf.navigationController setViewControllers:controllers animated:YES];
                            
                        }
                        
                        
                        
                        [SVProgressHUD dismiss];
                        
                    }];
                    
                    
                    // Successful response with page information and users array
                } errorBlock:^(QBResponse *response) {
                    // Handle error here
                }];
                
                
                
                
            }
          
            

            
        }
        
        
    }

    
}



-(IBAction)reset:(id)sender
{
    
    [selectedBlobidArray removeAllObjects];
    
    [self viewDidLoad];
    
}

- (NSMutableArray *)indexLettersForStrings:(NSMutableArray *)arrRepNames {
    NSMutableArray *letters = [NSMutableArray array];
    NSString *currentLetter = nil;
    for (NSString *string in arrRepNames) {
        if (string.length > 0) {
            NSString *letter = [string substringToIndex:1];
            if (![letter isEqualToString:currentLetter]) {
                [letters addObject:letter];
                currentLetter = letter;
            }
        }
    }
    return [NSMutableArray arrayWithArray:letters];
}

- (NSString *)chatNameFromUserNames:(NSMutableArray *)users {
    
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:users.count];
    
    for (QBUUser *user in users) {
        [names addObject:user.fullName];
    }
    if (users.count>1) {
          [names addObject:[QMApi instance].currentUser.fullName];
    }
  
    return [names componentsJoinedByString:@", "];
}



@end
