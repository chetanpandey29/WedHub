//
//  ReviewViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 12/01/17.
//  Copyright © 2017 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "AppUtils.h"
@interface ReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EDStarRatingProtocol>
@property NSMutableArray *arrReview;
@property (weak, nonatomic) IBOutlet UIView *vwReview;
@property (weak, nonatomic) IBOutlet UITableView *tblReview;
@property (weak, nonatomic) IBOutlet UILabel *lblReview;
@property (weak, nonatomic) IBOutlet EDStarRating *vwRating;
@property (weak, nonatomic) IBOutlet UITextView *tvComments;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnReview;
@property (strong,nonatomic) NSString *strCategoryId;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentPlace;
@property (strong,nonatomic) NSString *strUserType;
@end
