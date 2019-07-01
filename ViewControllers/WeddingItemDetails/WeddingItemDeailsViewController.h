//
//  WeddingItemDeailsViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "EDStarRating.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "ReviewViewController.h"

@interface WeddingItemDeailsViewController : UIViewController<EDStarRatingProtocol,UIGestureRecognizerDelegate>
- (IBAction)btnChatClick:(id)sender;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingView;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceRange;

@property (weak, nonatomic) IBOutlet UILabel *lblReviewCount;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIView *vwPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblReview;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UIView *vwVideos;
@property (strong,nonatomic) NSMutableArray *arrVendorDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhotoArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoArrow;
@property (nonatomic, strong) dispatch_group_t importGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnchat;
@property (weak, nonatomic) IBOutlet UIButton *btnChaticon;

@end
