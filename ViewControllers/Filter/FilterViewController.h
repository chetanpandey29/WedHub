//
//  FilterViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
@interface FilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
- (IBAction)btnApplyClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
