//
//  QMDialogsViewController.m
//  Q-municate
//
//  Created by Andrey Ivanov on 30/06/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMDialogsViewController.h"
#import "QMChatVC.h"
#import "QMCreateNewChatController.h"
#import "QMDialogsDataSource.h"
#import "REAlertView+QMSuccess.h"
#import "QMApi.h"
#import "DashboardViewController.h"
//#import "SyncViewController.h"
static NSString *const ChatListCellIdentifier = @"ChatListCell";

@interface QMDialogsViewController ()

<UITableViewDelegate, QMDialogsDataSourceDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) QMDialogsDataSource *dataSource;


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblName1;
@property (weak, nonatomic) IBOutlet UILabel *lblName2;
@property (weak, nonatomic) IBOutlet UILabel *lblMile;

@end

@implementation QMDialogsViewController

//chat history view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    SyncViewController *syncObj =[[SyncViewController alloc]init];
    
     if ([[syncObj getSendbuttonDisable:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]]isEqualToString:@"N"]) {
    _btnAddNewChatOrGroupChat.enabled=NO;
         
     }
    */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.accessibilityHint=[_dicCustomerData valueForKey:@"CustomerID"];
    
    self.dataSource = [[QMDialogsDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
    
    //setting top view labels
    [self ConfigureTopUserView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.dataSource fetchUnreadDialogsCount];
    [self.tableView reloadData];
}
- (void)ConfigureTopUserView {
    
    
}
- (IBAction)btnBackClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    DashboardViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
    

    
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatDialog *dialog = [self.dataSource dialogAtIndexPath:indexPath];
    
    
    if (dialog) {
        [self performSegueWithIdentifier:kChatViewSegueIdentifier sender:nil];
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
      //  [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
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
