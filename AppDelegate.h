//
//  AppDelegate.h
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Navigation.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "AppUtils.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "RootNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) RootNavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic) BOOL isFromChatList;
@property (nonatomic) BOOL isFromAppdelegate;
@property (strong) UIView *loadingView;

//Loader
-(void) showLoader;
-(void) hideLoader;

//InterNet Connection check
-(BOOL)checkInternetConnection;
- (void)connectToChat;
- (void)registerForRemoteNotifications;
@end

