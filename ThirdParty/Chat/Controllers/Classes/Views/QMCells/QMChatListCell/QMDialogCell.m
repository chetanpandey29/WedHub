//
//  QMDialogCell.m
//  Q-municate
//
//  Created by Igor Alefirenko on 31/03/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMDialogCell.h"
#import "QMApi.h"
#import "QMImageView.h"
#import "NSString+GTMNSStringHTMLAdditions.h"
//#import "SyncViewController.h"
//#import "DasbordViewController.h"

@interface QMDialogCell()

@property (strong, nonatomic) IBOutlet UILabel *unreadMsgNumb;
@property (strong, nonatomic) IBOutlet UILabel *groupMembersNumb;

@property (strong, nonatomic) IBOutlet UIImageView *groupNumbBackground;
@property (strong, nonatomic) IBOutlet UIImageView *unreadMsgBackground;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;

//-(IBAction)btnProfile:(id)sender;

@end

@implementation QMDialogCell
{
    // SyncViewController *syncObj ;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //syncObj = [[SyncViewController alloc]init];
    
    
}

- (void)setDialog:(QBChatDialog *)dialog {
    
    if (_dialog != dialog) {
        _dialog = dialog;
        
    }
    
    [self configureCellWithDialog:dialog];
}


- (void)configureCellWithDialog:(QBChatDialog *)chatDialog {
    
    BOOL isGroup = (chatDialog.type == QBChatDialogTypeGroup);
    
    /*
     NSMutableArray *arrCust = [syncObj GetLevalFromCust:[chatDialog.data valueForKey:@"LevelID"]];
     if (arrCust && arrCust.count>0) {
     if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"profileLevelidArray"]containsObject:[chatDialog.data valueForKey:@"LevelID"]]) {
     
     _btnProfile.hidden=NO;
     
     
     
     }
     else{
     _btnProfile.hidden=YES;
     }
     
     
     self.lvlIDlbl.text = [NSString stringWithFormat:@"%@ %@",[chatDialog.data valueForKey:@"LevelID"],[[arrCust objectAtIndex:0] valueForKey:@"AttributeValue"]];
     }
     else
     {
     _btnProfile.hidden=NO;
     if (![chatDialog.data valueForKey:@"LevelID"]) {
     self.lvlIDlbl.text = [NSString stringWithFormat:@"- , -"];
     }
     else{
     self.lvlIDlbl.text = [NSString stringWithFormat:@"%@ , -",[chatDialog.data valueForKey:@"LevelID"]];
     }
     
     
     
     }
     */
    
    
    self.descriptionLabel.text =  [chatDialog.lastMessageText gtm_stringByUnescapingFromHTML];
    
    self.groupMembersNumb.hidden = self.groupNumbBackground.hidden = !isGroup;
    self.unreadMsgBackground.hidden = self.unreadMsgNumb.hidden = (chatDialog.unreadMessagesCount == 0);
    self.unreadMsgNumb.text = [NSString stringWithFormat:@"%tu", chatDialog.unreadMessagesCount];
    
    
    //comment private chat code
    
    /*   if (!isGroup) {
     
     NSUInteger opponentID = [[QMApi instance] occupantIDForPrivateChatDialog:self.dialog];
     QBUUser *opponent = [[QMApi instance] userWithID:opponentID];
     
     NSURL *url = [NSURL URLWithString:opponent.avatarUrl];
     [self setUserImageWithUrl:url];
     
     self.titleLabel.text = opponent.fullName;
     
     } else {*/
    
    UIImage *img = [UIImage imageNamed:@"placeholder_group"];
    // [self.qmImageView setImageWithURL:[NSURL URLWithString:chatDialog.photo] placeholder:img options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    
    NSMutableArray *arrtemp =[[NSMutableArray alloc]initWithArray: [chatDialog valueForKey:@"occupantIDs"]];
    
    
    [arrtemp removeObject:[NSNumber numberWithLong:self.currentUser.ID]];
    
    if (arrtemp.count > 0){
        QBUUser *opponent = [[QMApi instance] userWithID:[arrtemp[0] integerValue]];
        
        
        self.titleLabel.hidden=NO;
        self.descriptionLabel.hidden=NO;

        
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",opponent.fullName,[[chatDialog valueForKey:@"data"] valueForKey:@"category"]];
        
        
        NSUInteger fileId = opponent.blobID;
        self.qmImageView.image = img;
        
        
        
        [QBRequest downloadFileWithID:fileId successBlock:^(QBResponse *response, NSData *fileData) {
            
            //NSString *urlString = [NSString stringWithFormat:@"%@",response.requestUrl];
            
            if (fileData != nil){
                
                UIImage *img = [UIImage imageWithData:fileData];
                self.qmImageView.image = img;
                self.qmImageView.layer.cornerRadius = self.qmImageView.frame.size.height/2;
                self.qmImageView.layer.masksToBounds=YES;
                
            }
            
            
            
            /*
             [self.qmImageView setImageWithURL:[NSURL URLWithString:urlString]
             placeholder:img
             options:SDWebImageHighPriority
             progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
             completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
             */
            
            
            // do something with fileData
        } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
            NSLog(@"download progress: %f", status.percentOfCompletion);
        } errorBlock:^(QBResponse *response) {
            NSLog(@"error: %@", response.error);
            
        }];
    }
    //}
    
    self.groupMembersNumb.text = [NSString stringWithFormat:@"%tu", chatDialog.occupantIDs.count];
    
    
    
    //SyncViewController *sync= [[SyncViewController alloc]init];
    
    
    /*
     
     if (arrtemp.count==1) {
     
     
     if ([[chatDialog.name componentsSeparatedByString:@","]count]>2) {
     self.titleLabel.text = chatDialog.name;
     }
     else{
     //NSString * title = [sync getDisplaynameFromIDS:arrtemp];
     //self.titleLabel.text = title;
     }
     
     
     }
     else{
     self.titleLabel.text = chatDialog.name;
     }
     */
    
    
}

@end