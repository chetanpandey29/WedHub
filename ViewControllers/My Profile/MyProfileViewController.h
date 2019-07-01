//
//  MyProfileViewController.h
//  WedHub
//
//  Created by Flexi_Mac2 on 23/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TPKeyboardAvoidingScrollView.h"
@interface MyProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;

@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *txtMinPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtMaxPrice;

@property (weak, nonatomic) IBOutlet UITextField *txtContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtFacebook;
@property (weak, nonatomic) IBOutlet UITextField *txtTwitter;
@property (weak, nonatomic) IBOutlet UITextField *txtSnapChat;
@property (weak, nonatomic) IBOutlet UITextField *txtInstagram;
@property (weak, nonatomic) IBOutlet UITextView *tvShortBio;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateProfile;

@property (weak, nonatomic) IBOutlet UIView *vwPhotos;

@property (weak, nonatomic) IBOutlet UIView *vwVideos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (weak, nonatomic) IBOutlet UIView *URLView;
@property (weak, nonatomic) IBOutlet UITextField *txtInsertURL;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCategoryTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMinPriceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMaxPriceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCollectionViewTopWithVideo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCollectionViewTopWithPhotos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPhotosHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constVideosTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPhotosTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constInstagramHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constInstagramTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSnapchatHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSnapchatTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTwitterHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTwitterTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFacebookHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFacebookTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCategoryHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMinHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMaxHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhotoArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFaceBookTopWithButton;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileURL;
@property (weak, nonatomic) IBOutlet UIButton *btnCopyURL;


@end
