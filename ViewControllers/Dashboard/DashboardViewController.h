//
//  DashboardViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"
#import "REFrostedViewController.h"
#import "AppUtils.h"
#import "FilterViewController.h"
#import "WeddingItemListViewController.h"

#import "ParallaxHeaderView.h"

@interface DashboardViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)btnFilter:(id)sender;
@property (strong, nonatomic) NSString *stTitle;

@property (nonatomic) NSDictionary *story;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFilter;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress1;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress2;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress3;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress4;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIView *vwAll;
@property (weak, nonatomic) IBOutlet UIView *vwAddress1;
@property (weak, nonatomic) IBOutlet UIView *vwAddress2;
@property (weak, nonatomic) IBOutlet UIView *vwAddress3;
@property (weak, nonatomic) IBOutlet UIView *vwAddress4;
@property (weak, nonatomic) IBOutlet UIView *vwMore;

@property (weak, nonatomic) IBOutlet UITableView *tblSearchCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consttblSearchCatHeight;
@property (weak, nonatomic) IBOutlet UIView *vwMoreLocation;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarLocation;
@property (weak, nonatomic) IBOutlet UITableView *tblLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnLocationApply;

@end
