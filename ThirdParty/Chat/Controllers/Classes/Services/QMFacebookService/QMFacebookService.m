//
//  QMFacebookService.m
//  Q-municate
//
//  Created by Igor Alefirenko on 26/03/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMFacebookService.h"


@implementation QMFacebookService 

NSString *const kQMHomeUrl = @"http://q-municate.com";
NSString *const kQMLogoUrl = @"https://files.quickblox.com/ic_launcher.png";
NSString *const kQMAppName = @"Q-municate";
NSString *const kQMDataKey = @"data";

+ (void)fetchMyFriends:(void(^)(NSArray *facebookFriends))completion {
    
   
}

+ (void)fetchMyFriendsIDs:(void(^)(NSArray *facebookFriendsIDs))completion {
    
    [self fetchMyFriends:^(NSArray *facebookFriends) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:facebookFriends.count];
        
        for (NSDictionary *user in facebookFriends) {
            [array addObject:[user valueForKey:@"id"]];
        }
        if (completion) completion(array);
    }];
}

NSString *const kFBGraphGetPictureFormat = @"https://graph.facebook.com/%@/picture?height=100&width=100&access_token=%@";

+ (NSURL *)userImageUrlWithUserID:(NSString *)userID {

   
    return nil;
}

+ (void)loadMe:(void(^)(NSDictionary *user))completion {
    
  
}

+ (void)inviteFriendsWithDelegate:(id<FBSDKAppInviteDialogDelegate>)delegate {
    
   
}

+ (void)logout {
    
   
}

+ (void)connectToFacebook:(void(^)(NSString *sessionToken))completion {
    
   }

@end
