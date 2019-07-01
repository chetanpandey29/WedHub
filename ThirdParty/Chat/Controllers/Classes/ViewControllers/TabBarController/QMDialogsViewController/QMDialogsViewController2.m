//
//  QMDialogsViewController.m
//  Q-municate
//
//  Created by Andrey Ivanov on 30/06/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMDialogsViewController2.h"
#import "QMChatVC.h"
#import "QMCreateNewChatController.h"
#import "QMDialogsDataSource2.h"
#import "REAlertView+QMSuccess.h"
#import "QMApi.h"
//#import "SyncViewController.h"
#import "SVProgressHUD.h"
static NSString *const ChatListCellIdentifier = @"ChatListCell";

@interface QMDialogsViewController2 ()

<UITableViewDelegate, QMDialogsDataSourceDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) QMDialogsDataSource2 *dataSource;


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblName1;
@property (weak, nonatomic) IBOutlet UILabel *lblName2;
@property (weak, nonatomic) IBOutlet UILabel *lblMile;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;

- (IBAction)btnProfile:(id)sender;

@end

@implementation QMDialogsViewController2
{
    //SyncViewController *syncObj;
    
    
}

//chat history view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    //syncObj = [[SyncViewController alloc]init];
    _dicCustomerData = [[NSMutableDictionary alloc]init];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // self.tableView.accessibilityHint=[_dicCustomerData valueForKey:@"CustomerID"];
    
    self.dataSource = [[QMDialogsDataSource2 alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    
    //setting top view labels
    [self ConfigureTopUserView];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
//    
//    NSMutableArray *dialogs = [[QMApi instance].chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO].mutableCopy;
//
//    NSLog(@"%d",DELE.lastDelete);
//    
//    
//    if (dialogs&&dialogs.count>DELE.lastDelete) {
//        [QBRequest updateDialog:[dialogs objectAtIndex:DELE.lastDelete] successBlock:^(QBResponse *responce, QBChatDialog *dialog) {
//            [[QMApi instance].chatService.dialogsMemoryStorage deleteChatDialogWithID:dialog.ID];
//            [[QMApi instance].chatService.dialogsMemoryStorage addChatDialog:dialog andJoin:YES completion:^(QBChatDialog * _Nonnull addedDialog, NSError * _Nullable error) {
//                [dialogs replaceObjectAtIndex:DELE.lastDelete withObject:dialog];
//                [self.tableView reloadData];
//            }];
//            
//            
//            
//        } errorBlock:^(QBResponse *response) {
//            
//        }];
//    }
//    

    
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.dataSource fetchUnreadDialogsCount];
    [self.tableView reloadData];
}
- (void)ConfigureTopUserView {
    
    self.lblName.text=[self.dicCustomerData valueForKey:@"CustomerName"];
    self.lblName1.text=[self.dicCustomerData valueForKey:@"Address"];
    self.lblName2.text=[self.dicCustomerData valueForKey:@"Zip"];
    self.lblMile.text=[self.dicCustomerData valueForKey:@"Mile"];
    
}


- (IBAction)btnProfile:(id)sender

{

    

    
    
    
    
    
    UIButton *btn = (UIButton *)sender;
    
  
    NSInteger indexRow = [btn.accessibilityValue integerValue];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexRow inSection:0];
    
    
    QBChatDialog *dialog2 = [self.dataSource dialogAtIndexPath:indexpath];
    
  
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
         __block   BOOL isLoad =NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        

        //insert into local tables
        //isLoad = [syncObj loadProfile:[dialog2.data valueForKey:@"LevelID"] acctype:[dialog2.data valueForKey:@"Type"] isdeleted:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            NSMutableArray *levelIDARRAY = [[[NSUserDefaults standardUserDefaults]objectForKey:@"profileLevelidArray"] mutableCopy];
            
            [levelIDARRAY removeObject:[dialog2.data valueForKey:@"LevelID"]];
            [[NSUserDefaults standardUserDefaults]setObject:levelIDARRAY forKey:@"profileLevelidArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            NSMutableDictionary *dictfff=[[NSMutableDictionary alloc]init];
            
            
          /*
            DasbordViewController *mapView=[[Navigation getStoryBord] instantiateViewControllerWithIdentifier:@"DasbordViewController"];
            [mapView getLabelValues:dictfff];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            SyncViewController *sync1=[[SyncViewController alloc]init];
            NSMutableArray *arrId=[[NSMutableArray alloc]initWithObjects:[dialog2.data valueForKey:@"LevelID"], nil];
            
            NSMutableArray *arrAttribute=[sync1 GetProfessionalListAttributesTypeCoreFilterID:arrId];
            
            if (arrAttribute.count>0) {
                [dict setObject:[[arrAttribute objectAtIndex:0] valueForKey:@"AttributeValue"] forKey:@"CustomerName"];
                [dict setObject:[[arrAttribute objectAtIndex:1] valueForKey:@"AttributeValue"] forKey:@"Address"];
                [dict setObject:[[arrAttribute objectAtIndex:2] valueForKey:@"AttributeValue"] forKey:@"City_State_Zip"];
                
            }
            
            [dict setObject:@"" forKey:@"Mile"];
            [dict setObject:[dialog2.data valueForKey:@"LevelID"] forKey:@"CustomerID"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"selectedHeader"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            mcustid = [dialog2.data valueForKey:@"LevelID"];
            header = [dialog2.data valueForKey:@"Type"];
            
            
            DELE.isStop=NO;
            
            
            
            
            [SVProgressHUD dismiss];
            
            
            [self.navigationController pushViewController:mapView animated:YES];
            
            */
            
            
        });
    });



    

}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//DELE.lastDelete = (int)indexPath.row;
    
    
    QBChatDialog *dialog = [self.dataSource dialogAtIndexPath:indexPath];

    
   // NSMutableArray *arrCust = [syncObj GetLevalFromCust:[dialog.data valueForKey:@"LevelID"]];
    /*
    if (arrCust==nil || arrCust.count==0) {
        
        
        
            [  _dicCustomerData setValue:@"-" forKey:@"CustomerName"];
            
            [  _dicCustomerData setValue:[dialog.data valueForKey:@"LevelID"] forKey:@"LevelId"];
        
            [  _dicCustomerData setValue:@"-" forKey:@"Address"];
    
            [  _dicCustomerData setValue:@"-" forKey:@"Zip"];
        
    }
    else{
        
        if (arrCust && arrCust.count>0) {
            
            [  _dicCustomerData setValue:[[arrCust objectAtIndex:0] valueForKey:@"AttributeValue"] forKey:@"CustomerName"];
            
            [  _dicCustomerData setValue:[[arrCust objectAtIndex:0] valueForKey:@"LevelId"] forKey:@"LevelId"];
        }
        
        if (arrCust && arrCust.count>1) {
            
            [  _dicCustomerData setValue:[[arrCust objectAtIndex:1] valueForKey:@"AttributeValue"] forKey:@"Address"];
        }
        if (arrCust && arrCust.count>2) {
            
            [  _dicCustomerData setValue:[[arrCust objectAtIndex:2] valueForKey:@"AttributeValue"] forKey:@"Zip"];
        }
        
        
    }
    
 */
    if (dialog) {
        
        UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        QMChatVC *objChat = [objStoryboard instantiateViewControllerWithIdentifier:@"QMChatVC"];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QBChatDialog *dialog = [self.dataSource dialogAtIndexPath:indexPath];
        objChat.dialog = dialog;
        objChat.dicCustomerData=self.dicCustomerData;
        
        [self.navigationController pushViewController:objChat animated:YES];
        
    }
    
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kChatViewSegueIdentifier]) {
        
        QMChatVC *chatController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QBChatDialog *dialog = [self.dataSource dialogAtIndexPath:indexPath];
        chatController.dialog = dialog;
        chatController.dicCustomerData=self.dicCustomerData;
        
    } else if ([segue.destinationViewController isKindOfClass:[QMCreateNewChatController class]]) {
        
        QMCreateNewChatController *QMCreateNewChatController = segue.destinationViewController;
        
        QMCreateNewChatController.dicCustomerData=self.dicCustomerData;
        
    }
}

#pragma mark - Actions

- (IBAction)createNewDialog:(id)sender
{
    if (!QMApi.instance.isInternetConnected) {
       // [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    
    if ([[QMApi instance].contactsOnly count] == 0) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_ERROR_WHILE_CREATING_NEW_CHAT", nil) actionSuccess:NO];
        return;
        
        //comment on 10/6/16
    }
    [self performSegueWithIdentifier:kCreateNewChatSegueIdentifier sender:nil];
}

#pragma mark - QMDialogsDataSourceDelegate

- (void)didChangeUnreadDialogCount:(NSUInteger)unreadDialogsCount {
    
    NSUInteger idx = [self.tabBarController.viewControllers indexOfObject:self.navigationController];
    if (idx != NSNotFound) {
        UITabBarItem *item = self.tabBarController.tabBar.items[idx];
        item.badgeValue = unreadDialogsCount > 0 ? [NSString stringWithFormat:@"%zd", unreadDialogsCount] : nil;
    }
}

- (IBAction)btnAddNewChatOrGroupChatClick:(id)sender {
    
    [self performSegueWithIdentifier:kCreateNewChatSegueIdentifier sender:nil];
}
@end
