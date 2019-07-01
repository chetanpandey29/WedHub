//
//  SignUpViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TTRangeSlider.h"
#import "WYPopoverController.h"
#import "DashboardPopUp.h"
@interface SignUpViewController : UIViewController<TTRangeSliderDelegate,KPPopUp,WYPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet TTRangeSlider *progressBarPriceRange;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnVendorCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnCoupleCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblVendorCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblCoupleCheck;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtFacebook;
@property (weak, nonatomic) IBOutlet UITextField *txtTwitter;
@property (weak, nonatomic) IBOutlet UITextField *txtSnapChat;
@property (weak, nonatomic) IBOutlet UITextField *txtInstagram;
@property (weak, nonatomic) IBOutlet UITextView *tvShortBio;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateAccount;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCategoryHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCategoryTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constlblPriceHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constlblPriceTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSliderHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFacebookHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFacebookTop;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTwitterHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTwitterTop;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSnapchatHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSnapchatTop;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constInstaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constInstaTop;
- (IBAction)btnCreateAccountClick:(id)sender;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtMinPrice;

@property (weak, nonatomic) IBOutlet UITextField *txtMaxPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMaxPriceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMaxPriceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMinPriceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMinPriceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTvShortBio;



@end
