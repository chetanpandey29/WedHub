//
//  FilterViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController
@synthesize txtCategory,txtCity,txtCountry,btnFilter,btnCancel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"Filter"];
    self.navigationController.navigationBar.barTintColor =   AppColor;
    
    [AppUtilsShared setPlaceHolderViewImage:txtCategory :@"downArrow" :@"Right"];
    [AppUtilsShared setPlaceHolderViewImage:txtCity :@"downArrow" :@"Right"];
    [AppUtilsShared setPlaceHolderViewImage:txtCountry :@"downArrow" :@"Right"];
    
    [AppUtilsShared setTextBoxBoarder:txtCategory];
    
    [AppUtilsShared setTextBoxBoarder:txtCountry];
    
    [AppUtilsShared setTextBoxBoarder:txtCity];
    
    
    
        [AppUtilsShared setButtonRadius:btnFilter];
        [AppUtilsShared setButtonRadius:btnCancel];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnApplyClick:(id)sender {
}

- (IBAction)btnCancelClick:(id)sender {
}
- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
    
}
@end
