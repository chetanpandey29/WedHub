//
//  QMApi+Notifications.m
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 9/24/15.
//  Copyright © 2015 Quickblox. All rights reserved.
//

#import "QMApi.h"
#import "QMChatUtils.h"
#import "MPGNotification.h"
#import "SDWebImageManager.h"
#import "QMChatService+AttachmentService.h"

@implementation QMApi (Notifications)


#pragma mark - Private chat notifications

- (void)sendContactRequestSendNotificationToUser:(QBUUser *)user completion:(void(^)(NSError *error, QBChatMessage *notification))completionBlock
{
    QBChatMessage *notification = [self notificationForUser:user];
    notification.messageType = QMMessageTypeContactRequest;
    [self sendNotification:notification completion:completionBlock];
}

- (void)sendContactRequestDeleteNotificationToUser:(QBUUser *)user completion:(void(^)(NSError *error, QBChatMessage *notification))completionBlock
{
    QBChatMessage *notification = [self notificationForUser:user];
    notification.messageType = QMMessageTypeDeleteContactRequest;
    [self sendNotification:notification completion:completionBlock];
}

- (QBChatMessage *)notificationForUser:(QBUUser *)user
{
    QBChatMessage *notification = [QBChatMessage message];
    notification.recipientID = user.ID;
    notification.senderID = self.currentUser.ID;
    notification.text = @"Contact request";  // contact request
    notification.dateSent = [NSDate date];
    return notification;
}

- (void)sendNotification:(QBChatMessage *)notification completion:(void(^)(NSError *error, QBChatMessage *notification))completionBlock
{
    QBChatDialog *dialog = [self.chatService.dialogsMemoryStorage privateChatDialogWithOpponentID:notification.recipientID];
    NSAssert(dialog, @"Dialog not found");
    [notification updateCustomParametersWithDialog:dialog];
    
    __weak __typeof(self)weakSelf = self;
    [self.chatService sendMessage:notification type:notification.messageType toDialog:dialog saveToHistory:YES saveToStorage:YES completion:^(NSError * _Nullable error) {
        //
        if (!error) {
            if (notification.messageType == QMMessageTypeContactRequest) {
                [weakSelf sendPushContactRequestNotification:notification];
            }
            
            if (completionBlock) completionBlock(nil, notification);
        } else {
            if (completionBlock) completionBlock(error, nil);
        }
    }];
}

#pragma mark - Push Notifications

- (void)sendPushContactRequestNotification:(QBChatMessage *)notification
{
    NSString *message = [QMChatUtils messageTextForPushWithNotification:notification];
    QBMEvent *event = [QBMEvent event];
    event.notificationType = QBMNotificationTypePush;
    event.usersIDs = [NSString stringWithFormat:@"%zd", notification.recipientID];
    event.type = QBMEventTypeOneShot;
    //
    // custom params
    NSDictionary  *dictPush = @{@"message" : message,
                                @"ios_badge": @"1",
                                @"ios_sound": @"default",
                                };
    //
    NSError *error = nil;
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:dictPush options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    //
    event.message = jsonString;
    
    [QBRequest createEvent:event successBlock:^(QBResponse *response, NSArray *events) {
        //
    } errorBlock:^(QBResponse *response) {
        //
    }];
}

- (void)handlePushNotificationWithDelegate:(id<QMNotificationHandlerDelegate>)delegate {
    if (self.pushNotification == nil) return;
    
    NSString *dialogID = self.pushNotification[kPushNotificationDialogIDKey];
    self.pushNotification = nil;
    
    @weakify(self);
    [[[self.chatService fetchDialogWithID:dialogID] continueWithBlock:^id _Nullable(BFTask<QBChatDialog *> * _Nonnull task) {
        //
        @strongify(self);
        if (task.result != nil) {
            // load users if needed
            [[self.usersService getUsersWithIDs:task.result.occupantIDs] continueWithBlock:^id _Nullable(BFTask<NSArray<QBUUser *> *> * _Nonnull usersTask) {
                //
                if ([delegate respondsToSelector:@selector(notificationHandlerDidSucceedFetchingDialog:)]) {
                    [delegate notificationHandlerDidSucceedFetchingDialog:task.result];
                }
                return nil;
            }];
            
            return [BFTask cancelledTask];
        }
        
        if ([delegate respondsToSelector:@selector(notificationHandlerDidStartLoadingDialogFromServer)]) {
            [delegate notificationHandlerDidStartLoadingDialogFromServer];
        }
        
        return [self.chatService loadDialogWithID:dialogID];
    }] continueWithBlock:^id _Nullable(BFTask<QBChatDialog *> * _Nonnull task) {
        //
        if (task.isCancelled) return nil;
        
        if ([delegate respondsToSelector:@selector(notificationHandlerDidFinishLoadingDialogFromServer)]) {
            [delegate notificationHandlerDidFinishLoadingDialogFromServer];
        }
        
        if (task.error != nil || task.result == nil) {
            if ([delegate respondsToSelector:@selector(notificationHandlerDidFailFetchingDialog)]) {
                [delegate notificationHandlerDidFailFetchingDialog];
            }
        } else {
            @strongify(self);
            [[self.usersService getUsersWithIDs:task.result.occupantIDs] continueWithBlock:^id _Nullable(BFTask<NSArray<QBUUser *> *> * _Nonnull usersTask) {
                //
                if ([delegate respondsToSelector:@selector(notificationHandlerDidSucceedFetchingDialog:)]) {
                    [delegate notificationHandlerDidSucceedFetchingDialog:task.result];
                }
                
                return nil;
            }];
        }
        
        return nil;
    }];
}

#pragma mark - Alerts

- (void)showMessageBarNotificationWithMessage:(QBChatMessage *)message chatDialog:(QBChatDialog *)chatDialog completionBlock:(MPGNotificationButtonHandler)block
{
    UIImage *img = nil;
    NSString *title = @"";
    
    if (chatDialog.type ==  QBChatDialogTypeGroup) {
        
        img = [self imageForKey:chatDialog.photo withPlaceHolder:[UIImage imageNamed:@"upic_placeholder_details_group"]];
  
        //SyncViewController *sync= [[SyncViewController alloc]init];
        
        //title = [sync getDisplaynameFromIDS:[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%lu",(unsigned long)message.senderID]]];
        
    }
    else if (chatDialog.type == QBChatDialogTypePrivate) {
        
        QBUUser *user = [self userWithID:message.senderID];
        
        title = user.fullName;
        img = [self imageForKey:user.avatarUrl withPlaceHolder:[UIImage imageNamed:@"upic_placeholderr"]];
    }
    
    NSString *messageText = nil;
    if (message.isNotificatonMessage) {
        messageText = [QMChatUtils messageTextForNotification:message];
    }
    else {
        messageText = message.encodedText;
    }
    
    if (self.messageNotification != nil) {
        
        [self.messageNotification dismissWithAnimation:NO];
    }
    
    self.messageNotification = [MPGNotification notificationWithTitle:title subtitle:messageText backgroundColor:[UIColor colorWithRed:0.32 green:0.33 blue:0.34 alpha:0.86] iconImage:img];
    [self.messageNotification setButtonConfiguration:MPGNotificationButtonConfigrationOneButton withButtonTitles:@[@"Reply"]];
    self.messageNotification.duration = 2.0;
    
    self.messageNotification.buttonHandler = block;
    
    [self.messageNotification show];

}

- (UIImage *)imageForKey:(NSString *)key withPlaceHolder:(UIImage *)placeHolder{
    
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:key];
    if (image == nil) {
        image = placeHolder;
    }
    
    return image;
}

@end
