//
//  QMCreateNewChatController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 31/03/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMAddUsersAbstractController.h"

@interface QMCreateNewChatController : QMAddUsersAbstractController

@property(nonatomic,retain) NSMutableDictionary *dicCustomerData;

- (IBAction)btnBackClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblName1;
@property (weak, nonatomic) IBOutlet UILabel *lblName2;
@property (weak, nonatomic) IBOutlet UILabel *lblMile;
@property (weak, nonatomic) IBOutlet UILabel *lblselect;
@property (weak, nonatomic) IBOutlet UIButton *createchat;


-(IBAction)createChat:(id)sender;
-(IBAction)reset:(id)sender;

@end
