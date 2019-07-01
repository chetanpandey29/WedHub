//
//  WeddingItemListViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "EDStarRating.h"
#import "WeddingItemDeailsViewController.h"
@interface WeddingItemListViewController : UIViewController<EDStarRatingProtocol>

@property (weak, nonatomic) NSString *stTitle;
@property (strong,nonatomic) NSMutableArray *arrSearchData;
@property (strong,nonatomic) NSString *strLocation;
@property (strong,nonatomic) NSString *strCategory;
@end
