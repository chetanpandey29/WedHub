//
//  QMTableViewCell.h
//  Qmunicate
//
//  Created by Andrey Ivanov on 11.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMImageView;

@interface QMTableViewCell : UITableViewCell 

@property (strong, nonatomic) id userData;
@property (strong, nonatomic) QBContactListItem *contactlistItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel,*lvlIDlbl;
@property (weak, nonatomic) IBOutlet QMImageView *qmImageView;
@property (weak, nonatomic) IBOutlet UIImageView *activeCheckBox;
@property (weak, nonatomic) IBOutlet UIImageView *activeunCheckBox;
- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;

@end
