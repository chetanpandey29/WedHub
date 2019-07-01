//
//  AppDelegate.m
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "AppDelegate.h"
#import "QMApi.h"
#import "QMSettingsManager.h"
#import "QMViewControllersFactory.h"
#import "QMSoundManager.h"
#import "SVProgressHUD.h"
#import "QMChatVC.h"
#import "launchScreenViewController.h"

@interface AppDelegate ()<QMChatServiceDelegate,QMChatConnectionDelegate,QMNotificationHandlerDelegate>
@property (nonatomic, strong) dispatch_group_t importGroup;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _isFromAppdelegate=YES;
   

    
    // Override point for customization after application launch.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
   _navigationController = [storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    [QBSettings setApplicationID:53534];
    
    [QBSettings setAuthKey:@"zAHRsbO5bZKVVen"];
    
    [QBSettings setAuthSecret:@"BHDS2xGcOv4Mkxn"];
    
    [QBSettings setAccountKey:@"AJCZTxc9K2RFuQGFKKzU"];
    [QBSettings setLogLevel:QBLogLevelDebug];
    [QBSettings enableXMPPLogging];
    
  [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = [UIColor colorWithRed:173.0/255.0 green:20.0/255.0 blue:87.0/255.0 alpha:1.0];
    }
    //QuickbloxWebRTC preferences
    [QBRTCClient initializeRTC];
    [QBRTCConfig setICEServers:[self quickbloxICE]];
    [QBRTCConfig mediaStreamConfiguration].audioCodec = QBRTCAudioCodecISAC;
    [QBRTCConfig setStatsReportTimeInterval:0.0f]; // set to 1.0f to enable stats report
    
    if (launchOptions != nil) {
        NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        [[QMApi instance] setPushNotification:notification];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[QMApi instance] handlePushNotificationWithDelegate:self];
        });
    }
    
    
    
    [[QMApi instance].chatService addDelegate:self];

[self connectToChat];
   
//    hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//    
//        // Set the label text.
//        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
//        // You can also adjust other label properties if needed.
//        // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
//        hud.margin = 10.f;
//        hud.yOffset = 150.f;
//        hud.removeFromSuperViewOnHide = YES;
//    
//        [hud hide:YES afterDelay:2];
//        [hud showAnimated:YES];
//       [self connectToChat];
//    

       return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    NSArray *urls = @[
                      @"turn.quickblox.com",            //USA
                      @"turnsingapore.quickblox.com",   //Singapore
                      @"turnireland.quickblox.com"      //Ireland
                      ];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:urls.count];
    
    for (NSString *url in urls) {
        
        QBRTCICEServer *stunServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"stun:%@", url]
                                                          username:@""
                                                          password:@""];
        
        
        QBRTCICEServer *turnUDPServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"turn:%@:3478?transport=udp", url]
                                                             username:userName
                                                             password:password];
        
        QBRTCICEServer *turnTCPServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"turn:%@:3478?transport=tcp", url]
                                                             username:userName
                                                             password:password];
        
        [result addObjectsFromArray:@[stunServer, turnTCPServer, turnUDPServer]];
    }
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AutoLogin"]isEqualToString:@"YES"])
    {
        if ([[QMApi instance] currentUser]) {
            [[QMApi instance] applicationWillResignActive];
        }
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AutoLogin"]isEqualToString:@"YES"])
    {
        if ([[QMApi instance] currentUser]) {
            [[QMApi instance] applicationDidBecomeActive:^(BOOL success) {}];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark
#pragma mark -  Loader
#pragma mark


-(void) showLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD show];
    });
}

-(void) hideLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark
#pragma mark - Check Internet connection
#pragma mark

-(BOOL)checkInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
        return YES;
    }
    else
    {
        [self hideLoader];
        ShowAlert(NOINTERNET);
        return NO;
    }
}
- (void)connectToChat
{

    
if([[AppUtilsShared getPreferences:@"autoLogin"]isEqualToString:@"YES"])
{
 
    [[QMApi instance] loginWithEmail:[AppUtilsShared getPreferences:@"Emailid"] password:@"admin@123" rememberMe:YES completion:^(BOOL success)
     {
        
         if (success)
         {
             
             [[QMApi instance] connectChat:^(BOOL loginSuccess) {
                 
                 QBUUser *usr = [QMApi instance].currentUser;
                 if (!usr.isImport) {
                     self.importGroup = dispatch_group_create();
                     dispatch_group_enter(self.importGroup);
                     
                     /*
                      [[QMApi instance] importFriendsFromFacebook:^(BOOL success) {
                      //
                      dispatch_group_leave(self.importGroup);
                      }];
                      dispatch_group_enter(self.importGroup);
                      [[QMApi instance] importFriendsFromAddressBookWithCompletion:^(BOOL succeded, NSError *error) {
                      //
                      dispatch_group_leave(self.importGroup);
                      }];
                      */
                     
                     dispatch_group_notify(self.importGroup, dispatch_get_main_queue(), ^{
                         //
                         usr.isImport = YES;
                         QBUpdateUserParameters *params = [QBUpdateUserParameters new];
                         params.customData = usr.customData;
                       
                         [[QMApi instance] updateCurrentUser:params image:nil progress:nil completion:^(BOOL success) {
                             
                             dispatch_group_leave(self.importGroup);
                             
                             
                            
                             
                         }];
                     });
                 }
                 
                 // open chat if app was launched by push notifications
                 //  NSDictionary *push = [[QMApi instance] pushNotification];
                 
                 
                    [_loadingView setHidden:YES];
                 [[QMApi instance] fetchAllData:nil];
             }];
         }
         else{
             [AppUtilsShared ShowNotificationwithMessage:@"Somthing Went Wrong!!" withcolor:[UIColor redColor]];
         }
          
     }
     ];
    }
   }
        
- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //  New way, only for updated backends
    //
    QBMSubscription *subscription = [QBMSubscription subscription];
    subscription.notificationChannel = QBMNotificationChannelAPNS;
    subscription.deviceUDID = deviceIdentifier;
    subscription.deviceToken = deviceToken;
    
    [QBRequest createSubscription:subscription successBlock:^(QBResponse *response, NSArray *objects) {
        
        NSLog(@"Successfull response!");
        [SVProgressHUD dismiss];
        
    } errorBlock:^(QBResponse *response) {
        
        [AppUtilsShared ShowNotificationwithMessage:response.error withcolor:REDCOLOR];
        
        [SVProgressHUD dismiss];
    }];
    
    //    // Old way
    //    //
    //    [QBRequest registerSubscriptionForDeviceToken:deviceToken uniqueDeviceIdentifier:deviceIdentifier
    //                                     successBlock:^(QBResponse *response, NSArray *subscriptions) {
    //                                         NSLog(@"Successfull response!");
    //                                     } errorBlock:^(QBError *error) {
    //                                         NSLog(@"Response error:%@", error);
    //
    //
    //                                     }];
}
#pragma mark - QMNotificationHandlerDelegate protocol

- (void)notificationHandlerDidSucceedFetchingDialog:(QBChatDialog *)chatDialog {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[QBChat instance] isConnected]) {
        UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        
        
        
        
        QMChatVC *objQMChatVC = (QMChatVC *)[objStoryboard instantiateViewControllerWithIdentifier:@"QMChatVC"];
        objQMChatVC.dialog = chatDialog;
        
        
     /*
        NSMutableArray *arrCust =[[NSMutableArray alloc]init ];
        SynMasterDele=[[SyncViewController alloc]init];
        arrCust =[SynMasterDele GetLevalFromCust:[chatDialog.data valueForKey:@"LevelID"]];
        
        
        
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
        
        [ dictData setValue:[[arrCust objectAtIndex:1] valueForKey:@"AttributeValue"] forKey:@"Address"];
        [ dictData setValue:[[arrCust objectAtIndex:0] valueForKey:@"AttributeValue"] forKey:@"CustomerName"];
        [ dictData setValue:[chatDialog.data valueForKey:@"LevelID"] forKey:@"LevelID"];
        [ dictData setValue:[chatDialog.data valueForKey:@"Mile"] forKey:@"Mile"];
        [ dictData setValue:[[arrCust objectAtIndex:2] valueForKey:@"AttributeValue"] forKey:@"Zip"];
        
        [ dictData setValue:@"" forKey:@"location_field"];
        [ dictData setValue:@"CustomParameter" forKey:@"class_name"];
        
        
        objQMChatVC.dicCustomerData =dictData;*/
        
     
        [self.navigationController pushViewController:objQMChatVC animated:YES];
        
       // self.window.rootViewController = objQMChatVC;
        [SVProgressHUD dismiss];
        [[QMApi instance] fetchAllData:nil];
        
    }else{
        
        [SVProgressHUD show];
        
        
        NSString *QuickEmail =[AppUtilsShared getPreferences:@"Emailid"];
        
        
        
        [[QMApi instance] loginWithEmail:QuickEmail password:@"admin@123" rememberMe:YES completion:^(BOOL success) {
            if (success) {
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                
                [[QMApi instance] connectChat:^(BOOL loginSuccess) {
                    if (loginSuccess) {
                        
                        UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                        
                        QMChatVC *objQMChatVC = (QMChatVC *)[objStoryboard instantiateViewControllerWithIdentifier:@"QMChatVC"];
                        objQMChatVC.dialog = chatDialog;
                        NSMutableArray *arrCust =[[NSMutableArray alloc]init ];
                        /*SynMasterDele=[[SyncViewController alloc]init];
                        arrCust =[SynMasterDele GetLevalFromCust:[chatDialog.data valueForKey:@"LevelID"]];
                        
                        
                        
                        NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
                        
                        [ dictData setValue:[[arrCust objectAtIndex:1] valueForKey:@"AttributeValue"] forKey:@"Address"];
                        [ dictData setValue:[[arrCust objectAtIndex:0] valueForKey:@"AttributeValue"] forKey:@"CustomerName"];
                        [ dictData setValue:[chatDialog.data valueForKey:@"LevelID"] forKey:@"LevelID"];
                        [ dictData setValue:[chatDialog.data valueForKey:@"Mile"] forKey:@"Mile"];
                        [ dictData setValue:[[arrCust objectAtIndex:2] valueForKey:@"AttributeValue"] forKey:@"Zip"];
                        
                        [ dictData setValue:@"" forKey:@"location_field"];
                        [ dictData setValue:@"CustomParameter" forKey:@"class_name"];
                        
                        
                        objQMChatVC.dicCustomerData =dictData;*/
                             [self.navigationController pushViewController:objQMChatVC animated:YES];
                        //self.window.rootViewController = objQMChatVC;
                        [SVProgressHUD dismiss];
                        [[QMApi instance] fetchAllData:nil];
                    }
                }];
            }
        }];
        
        
        
        
        
        
        
        
    }
}
@end
