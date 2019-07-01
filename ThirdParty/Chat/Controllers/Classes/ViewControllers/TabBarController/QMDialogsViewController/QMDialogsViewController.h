//
//  QMChatRoomListController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 31/03/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMDialogsViewController : UIViewController

@property(nonatomic,retain) NSMutableDictionary *dicCustomerData;

//Plus button
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewChatOrGroupChat;

- (IBAction)btnAddNewChatOrGroupChatClick:(id)sender;

@end
