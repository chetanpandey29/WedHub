//
//  QMMainTabBarController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 21/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMMainTabBarController : UITabBarController
<
QMChatServiceDelegate,
QMChatConnectionDelegate
>

@end
