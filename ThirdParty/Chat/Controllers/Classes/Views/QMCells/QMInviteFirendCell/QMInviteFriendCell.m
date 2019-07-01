//
//  QMInviteFriendsCell.m
//  Q-municate
//
//  Created by Igor Alefirenko on 24.03.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMInviteFriendCell.h"
#import "ABPerson.h"
#import "QMApi.h"

@interface QMInviteFriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *activeCheckbox;

@end

@implementation QMInviteFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.activeCheckbox.hidden = YES;
}


- (void)setCheck:(BOOL)check {
    
    if (_check != check) {
        _check = check;
        self.activeCheckbox.hidden = !check;
    }
}

#pragma mark - Actions

- (IBAction)pressCheckBox:(id)sender {

    //self.check ^= 1;
    //[self.delegate containerView:self didChangeState:sender];
}

@end
