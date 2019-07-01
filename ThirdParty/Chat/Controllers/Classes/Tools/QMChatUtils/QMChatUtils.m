//
//  QMChatUtils.m
//  Q-municate
//
//  Created by Igor Alefirenko on 17.10.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMChatUtils.h"
#import "QMApi.h"

@implementation QMChatUtils


+ (NSString *)messageTextForNotification:(QBChatMessage *)notification
{
    NSString *messageText = nil;
    QBUUser *sender = [[QMApi instance] userWithID:notification.senderID];
    QBUUser *recipient = [[QMApi instance] userWithID:notification.recipientID];
    
    switch (notification.messageType) {
        case QMMessageTypeContactRequest:
        {
            messageText = (notification.senderID == QMApi.instance.currentUser.ID) ?  NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_ME",nil) : [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_OPPONENT", @"{FullName}"), sender.fullName];
        }
            break;
            
        case QMMessageTypeAcceptContactRequest:
        {
            messageText = (notification.senderID == QMApi.instance.currentUser.ID) ? NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_CONFIRM_FOR_ME", nil) : NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_CONFIRM_FOR_OPPONENT", nil);
        }
            break;
            
        case QMMessageTypeRejectContactRequest:
        {
            messageText = (notification.senderID == QMApi.instance.currentUser.ID) ? NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_REJECT_FOR_ME",nil) : NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_REJECT_FOR_OPPONENT", nil);
        }
            break;
            
        case QMMessageTypeDeleteContactRequest:
        {
            messageText = (notification.senderID == QMApi.instance.currentUser.ID) ?
            [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_DELETE_FOR_ME", @"{FullName}"), recipient.fullName] :
            [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_DELETE_FOR_OPPONENT", @"{FullName}"), sender.fullName];
        }
            break;
            
        case QMMessageTypeUpdateGroupDialog:
        {
            switch (notification.dialogUpdateType) {
                case QMDialogUpdateTypeName:
                    messageText = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_UPDATE_GROUP_NAME_TEXT", nil), sender.fullName, notification.dialogName];
                    break;
                    
                case QMDialogUpdateTypePhoto:
                    messageText = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_UPDATE_GROUP_AVATAR_TEXT", nil), sender.fullName];
                    break;
                    
                case QMDialogUpdateTypeOccupants:
                {
                    if ([notification.addedOccupantsIDs count] > 0) {
                        
                        NSArray *users = [[QMApi instance] usersWithIDs:notification.addedOccupantsIDs];
                        NSString *fullNameString = [self fullNamesString:users];
                        messageText = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_ADD_USERS_TO_EXIST_GROUP_CONVERSATION_TEXT", nil), sender.fullName, fullNameString];
                    } else if ([notification.deletedOccupantsIDs count] > 0) {
                        
                        QBUUser *leavedUser = [[QMApi instance] userWithID:[[notification.deletedOccupantsIDs firstObject] integerValue]];
                        messageText = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_LEAVE_GROUP_CONVERSATION_TEXT", nil), leavedUser.fullName];
                    }
                }
                    
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return messageText;
}

+ (NSString *)messageTextForPushWithNotification:(QBChatMessage *)notification
{
    NSString *message = nil;
    QBUUser *sender = [[QMApi instance] userWithID:notification.senderID];
    if (notification.messageType == QMMessageTypeContactRequest) {
        message = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_OPPONENT", @"{FullName}"), sender.fullName];
    } else if (notification.messageType == QMMessageTypeAcceptContactRequest) {
        message = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_CONFIRM_FOR_PUSH", @"{FullName}"), sender.fullName];
    } else if (notification.messageType == QMMessageTypeRejectContactRequest) {
        message = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_REJECT_FOR_PUSH", @"{FullName}"), sender.fullName];
    } else if (notification.messageType == QMMessageTypeDeleteContactRequest) {
        message = [NSString stringWithFormat:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_DELETE_FOR_OPPONENT", @"{FullName}"), sender.fullName];
    }
    
    return message;
}

+ (NSString *)fullNamesString:(NSArray *)users
{
    if (users.count == 0) {
        return @"Unknown users";
    }
    NSMutableString *mutableString = [NSMutableString new];
    for (QBUUser *usr in users) {
        if (usr.fullName) {
                [mutableString appendString:usr.fullName];
        }
        else{
            [mutableString appendString:@"-"];
            
        }
        [mutableString appendString:@", "];
    }
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 2, 2)];
    return mutableString;
}

+ (NSString *)idsStringWithoutSpaces:(NSArray *)users
{
    NSMutableString *mutableString = [NSMutableString new];
    for (QBUUser *usr in users) {
        [mutableString appendString:[NSString stringWithFormat:@"%lu", (unsigned long)usr.ID]];
        [mutableString appendString:@","];
    }
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
    return mutableString;
}

+ (NSString *)messageForText:(NSString *)text participants:(NSArray *)participants
{
    NSString *addedUsersNames = [self fullNamesString:participants];
    return [NSString stringWithFormat:text, [QMApi instance].currentUser.fullName, addedUsersNames];
}

@end
