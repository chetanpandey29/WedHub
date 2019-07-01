//
//  QMChatIncomingCell.h
//  QMChatViewController
//
//  Created by Andrey Ivanov on 29.05.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatCell.h"

/**
 *  Chat message cell typically used for opponent's messages.
 */
@interface QMChatIncomingCell : QMChatCell
@property (weak, nonatomic) IBOutlet UIView *viewImage;

@end
