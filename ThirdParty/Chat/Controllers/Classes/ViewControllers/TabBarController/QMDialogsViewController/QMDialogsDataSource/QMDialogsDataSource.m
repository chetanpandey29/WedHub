//
//  QMDialogsDataSource.m
//  Qmunicate
//
//  Created by Andrey Ivanov on 13.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMDialogsDataSource.h"
#import "QMDialogCell.h"
#import "SVProgressHUD.h"
#import "QMApi.h"

@interface QMDialogsDataSource()
<
UITableViewDataSource,
QMChatServiceDelegate,
QMChatConnectionDelegate,
QMUsersServiceDelegate
>

//chat history table is loaded from here
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic, readonly) NSMutableArray *dialogs;
@property (assign, nonatomic) NSUInteger unreadDialogsCount;

@end

@implementation QMDialogsDataSource
{
    NSString *strLvl;
    
    NSMutableArray *userArray;
}
- (instancetype)initWithTableView:(UITableView *)tableView {
    strLvl=tableView.accessibilityHint;
    
    
    self = [super init];
    if (self) {
        [[QMApi instance].chatService addDelegate:self];
        [[QMApi instance].usersService addDelegate:self];
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    
    return self;
}

- (void)updateGUI {
    
    [self.tableView reloadData];
    [self fetchUnreadDialogsCount];
}

- (void)setUnreadDialogsCount:(NSUInteger)unreadDialogsCount {
    
    if (_unreadDialogsCount != unreadDialogsCount) {
        _unreadDialogsCount = unreadDialogsCount;
        
        [self.delegate didChangeUnreadDialogCount:_unreadDialogsCount];
    }
}

- (void)fetchUnreadDialogsCount {
    
    NSArray * dialogs = [[QMApi instance] dialogHistory];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unreadMessagesCount > 0"];
    NSArray *result = [dialogs filteredArrayUsingPredicate:predicate];
    self.unreadDialogsCount = result.count;
}

- (void)insertRowAtIndex:(NSUInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSUInteger count = self.dialogs.count;
    return count > 0 ? count:1;
}

- (QBChatDialog *)dialogAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *dialogs = self.dialogs;
    if (dialogs.count == 0) {
        return nil;
    }
    
    QBChatDialog *dialog = dialogs[indexPath.row];
    return dialog;
}

//comment
/*
- (NSMutableArray *)dialogs {

    NSMutableArray *dialogs = [[QMApi instance].chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO].mutableCopy;

    return dialogs;
}

*/
- (NSMutableArray *)dialogs {
    
    NSMutableArray *dialogs = [[QMApi instance].chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO].mutableCopy;
    userArray = [[NSMutableArray alloc]init];
    
    for (int f=0; f<dialogs.count; f++) {
        
        QBChatDialog *dialog = dialogs[f];
        
                [userArray addObject:dialog];
            }
            
            
        
        
    
    
    
    return userArray;
}


NSString *const kQMDialogCellID = @"QMDialogCell";
NSString *const kQMDontHaveAnyChatsCellID = @"QMDontHaveAnyChatsCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *dialogs = self.dialogs;
    
    if (dialogs.count == 0) {
        QMDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:kQMDontHaveAnyChatsCellID];
        cell.userInteractionEnabled=NO;
        return cell;
    }
    
    QMDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:kQMDialogCellID];
    
  
    
    QBChatDialog *dialog = dialogs[indexPath.row];
    cell.dialog = dialog;
    
    return cell;
}

#pragma mark - UITableViewDataSource Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
#if DELETING_DIALOGS_ENABLED
    return YES;
#else
    return NO;
#endif
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [SVProgressHUD show];
        QBChatDialog *dialog = [self dialogAtIndexPath:indexPath];
        
        @weakify(self);
        //        [[[QMApi instance].chatService deleteDialogWithID:dialog.ID] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        //            @strongify(self);
        //            [SVProgressHUD dismiss];
        //           // (self.dialogs.count == 0) ?
        //            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        //          //  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //            return nil;
        //        }];
        
        
        [QBRequest deleteDialogsWithIDs:[NSSet setWithObject:dialog.ID] forAllUsers:YES
                           successBlock:^(QBResponse *response, NSArray *deletedObjectsIDs, NSArray *notFoundObjectsIDs, NSArray *wrongPermissionsObjectsIDs) {
                               @strongify(self);
                               [SVProgressHUD dismiss];
                               
                               [[[QMApi instance].chatService deleteDialogWithID:dialog.ID] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
                                   @strongify(self);
                                   [SVProgressHUD dismiss];
                                   
                                   [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                   
                                   return nil;
                               }];
                               
                               [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                               
                               
                           } errorBlock:^(QBResponse *response) {
                               
                               if (response.status == 403) {
                                   [[[QMApi instance].chatService deleteDialogWithID:dialog.ID] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
                                       @strongify(self);
                                       [SVProgressHUD dismiss];
                                       
                                       [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                       
                                       return nil;
                                   }];
                               }
                               
                               [SVProgressHUD dismiss];
                           }];
        
        
        
        
    }
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
    
    [[[QMApi instance].usersService getUsersWithIDs:chatDialog.occupantIDs] continueWithBlock:^id(BFTask<NSArray<QBUUser *> *> *task) {
        
        [self updateGUI];
        
        return nil;
    }];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray<QBChatDialog *> *)dialogs {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
    [self updateGUI];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    [self updateGUI];
}

#pragma mark Contact List Serice Delegate

- (void)usersService:(QMUsersService *)usersService didLoadUsersFromCache:(NSArray<QBUUser *> *)users {
    [self.tableView reloadData];
}

- (void)usersService:(QMUsersService *)usersService didAddUsers:(NSArray<QBUUser *> *)user {
    [self.tableView reloadData];
}

@end
