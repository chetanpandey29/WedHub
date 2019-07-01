//
//  AppUtils.h
//  Situ
//
//  Created by Kunj Patel on 29/06/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "MessageConstant.h"
#import <CoreLocation/CoreLocation.h>
#import "REFrostedViewController.h"
#import "CRToastView.h"
#import "CRToast.h"

@interface AppUtils : NSObject<UIAlertViewDelegate>


#pragma mark ClASS SETUP
+ (AppUtils *)sharedInstance;

//Validation of Email and MobileNo
-(BOOL)validateEmailWithString:(NSString*)email;
-(NSString *)validateMobileandSetText :(NSString *)stMobileNo;

//Navigation Bar Item add
-(UIBarButtonItem *)getNavigationBackButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector;

-(UIBarButtonItem *)getCancleButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector;

-(UILabel *)getNavigationTitle:(NSString *)strTitle;

-(UIBarButtonItem *)getNavigationButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector;

#pragma mark Notification Color
-(void)ShowNotificationwithMessage:(NSString *)message withcolor:(UIColor *)color;



#pragma mark NS USERDEFAULT AND PREFERENCERS
-(NSString *)setForNull:(NSString*)strText;



#pragma mark Set and Get Preference Method
-(void)setPreferences:(id)value withKey:(NSString *)key;
-(id)getPreferences:(NSString *)key;
-(void)setPreferencesBOOL:(BOOL)value withKey:(NSString *)key;
-(BOOL)getPreferencesBOOL:(NSString *)key;
-(BOOL)isPreferencesExist:(NSString *)key;
//-(void)deletePreference:(NSString *)key;
-(void)clearAllPrefrences;


#pragma mark COLOR CONVERT
-(UIColor*)colorWithHexString:(NSString*)hex;
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
-(UIImage *)imageFromColor:(UIColor *)color frame:(CGRect)rect;

#pragma mark PopUpAnimation
- (void)animateViewHeight:(UIView*)animateView withAnimationType:(NSString*)animType;

#pragma mark Device Id
- (NSString *)deviceUUID;

-(void)setTextBoxBoarder : (UITextField *)textfield;
-(void)setTextviewBoarder : (UITextView *)textview;
-(void)setButtonRadius : (UIButton *)button;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIView *view;

-(void)setPlaceHolderViewImage :(UITextField *)textfield : (NSString *)imgName :(NSString *)LeftOrRight;
@property(nonatomic,retain)NSString *shippingDate;
@end
