//
//  MenuTableViewController.h
//  LittleStarAdmin
//
//  Created by Kunj Patel on 9/28/15.
//  Copyright © 2015 Openxcell Technolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"
#import "MyProfileViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface MenuTableViewController : UITableViewController<UIAlertViewDelegate>

{
    
    
    
  
}
@property(strong,nonatomic)NSMutableArray *arrImagesGray;
@property(strong,nonatomic)NSMutableArray *arrNames;
@property (strong, nonatomic) UIWindow *window;


@end
