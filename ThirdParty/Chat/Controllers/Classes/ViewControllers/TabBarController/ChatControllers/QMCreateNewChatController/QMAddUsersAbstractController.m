//
//  QMAddUsersAbstractController.m
//  Qmunicate
//
//  Created by Igor Alefirenko on 17/06/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMAddUsersAbstractController.h"
#import "QMInviteFriendCell.h"
#import "QMApi.h"

NSString *const kCreateChatCellIdentifier = @"CreateChatCell";

@interface QMAddUsersAbstractController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *performButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//top custom view
- (IBAction)btnResetClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (weak, nonatomic) IBOutlet UILabel *lblSelectedCount;


@end

@implementation QMAddUsersAbstractController



#pragma mark - LifeCycle

- (void)viewDidLoad {
    self.selectedFriends = [NSMutableArray array];
    
    [super viewDidLoad];
    
    [self updateGUI];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateGUI {
    
    self.lblSelectedCount.text=[NSString stringWithFormat:@"%zd Selected", self.selectedFriends.count];
    
    self.title = [NSString stringWithFormat:@"%zd Selected", self.selectedFriends.count];
    BOOL enabled = self.selectedFriends.count > 0;
    self.performButton.enabled = enabled;
    
    self.resetButton.enabled = enabled;
    [self.tableView reloadData];
}

#pragma mark - Actions

/** Override this methods */
- (IBAction)performAction:(id)sender {
   CHECK_OVERRIDE();
}

- (IBAction)pressResetButton:(UIButton *)sender {
    
    [self.selectedFriends removeAllObjects];
    [self updateGUI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.contacts.count; //comment on 10/6/16
    
    //return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QMInviteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCreateChatCellIdentifier];
    
    //cell.userData =[NSNumber numberWithInteger:indexPath.row] ;
    
    //comment on 10/6/16
    
    //need to change - have pass USERS List here
    QBUUser *friend = self.contacts[indexPath.row];
    
    cell.contactlistItem = [[QMApi instance] contactItemWithUserID:friend.ID];
    cell.userData = friend;
    cell.check = [self.selectedFriends containsObject:friend];
    //cell.contentView.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //return;
    
    
    //comment on 10/6/16
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QBUUser *checkedUser = self.contacts[indexPath.row];
    
    BOOL contains = [self.selectedFriends containsObject:checkedUser];
    contains ? [self.selectedFriends removeObject:checkedUser] : [self.selectedFriends addObject:checkedUser];
    [self updateGUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        
        return 44;
    }
    return 44;
}
- (IBAction)btnResetClick:(id)sender {
    
    
    [self.selectedFriends removeAllObjects];
    [self updateGUI];
    
}

@end
