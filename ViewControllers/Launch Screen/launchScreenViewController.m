//
//  launchScreenViewController.m
//  My CC
//
//  Created by Flexi_Mac_4 on 27/06/16.
//  Copyright © 2016 flexiware solution. All rights reserved.
//

#import "launchScreenViewController.h"
#import "GiFHUD.h"
#import "ViewController.h"
#import "Constant.h"
#import "DashboardViewController.h"
#import "SVProgressHUD.h"
//#import "QMApi.h"

@interface launchScreenViewController ()

@end

@implementation launchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (Delegate.isFromChatList==NO) {
        self.navigationController.navigationBar.hidden=YES;
        
        //Setup GiFHUD image
        [GiFHUD setGifWithImageName:@"loader.gif"];
        [GiFHUD show];
        
        // dismiss after 2 seconds
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,2 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //[Delegate connectToChat];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            DashboardViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
            
            [GiFHUD dismiss];
        }
                       
                       );
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
