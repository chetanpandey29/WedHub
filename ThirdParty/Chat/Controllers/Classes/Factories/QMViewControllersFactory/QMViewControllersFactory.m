//
//  QMViewControllersFactory.m
//  Q-municate
//
//  Created by Igor Alefirenko on 23.09.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMViewControllersFactory.h"
#import "QMChatVC.h"
#import "QMApi.h"

@implementation QMViewControllersFactory
{
    NSDictionary *dictdata;
}


+ (UIViewController *)chatControllerWithDialogID:(NSString *)dialogID
{
    QBChatDialog *dialog = [[QMApi instance] chatDialogWithID:dialogID];
    
    QMChatVC *chatVC = (QMChatVC *)[[UIStoryboard storyboardWithName:@"Chat" bundle:nil] instantiateViewControllerWithIdentifier:@"QMChatVC"];
    
    chatVC.dicCustomerData=dialogID.accessibilityElements;
    
    
    
    chatVC.dialog = dialog;
    return chatVC;
}


+ (UIViewController *)chatControllerWithDialog:(QBChatDialog *)dialog
{
    QMChatVC *chatVC = (QMChatVC *)[[UIStoryboard storyboardWithName:@"Chat" bundle:nil] instantiateViewControllerWithIdentifier:@"QMChatVC"];
    chatVC.dialog = dialog;
    return chatVC;
}

@end
