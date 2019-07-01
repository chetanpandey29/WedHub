//
//  MessageConstant.h
//  Trukker
//
//  Created by Kunj on 3/4/16.
//  Copyright (c) 2015 Flexiware Solutions. All rights reserved.
//

#ifndef Trukker_MessageConstant_h
#define Trukker_MessageConstant_h


#endif

/********************************************** ShowAlert ***********************************************/

#define ShowAlert( msg ) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];\
[alert show];\
}


#define NOINTERNET              @"Unable to Connect to the Internet."

#define C_Logout                @"Are you sure you want to Logout?"



#define C_Req_MobileNo          @"Please Enter Mobile Number!"
#define C_Req_Password          @"Please Enter Password!"

#define C_Validate_MobileNo          @"Please Enter Valid Mobile Number!"