//
//  WebServiceClass.h
//  StartUp
//
//  Created by Kunj Patel on 6/17/15.
//  Copyright (c) 2015 Kunj Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHTTPRequest.h"
#import "WebServiceConstant.h"


@interface WebServiceClass : NSObject

+(id)werserviceSharedManager;

-(void)postRequestWithUrl:(NSString *)strURL andParameters:(NSData *)mParameters  showLoader:(BOOL)isLoader response:(void (^)(id response, NSError *error, BOOL Success))getResponse;

-(void)getRequestWithUrl:(NSString *)strURL showLoader:(BOOL)isLoader response:(void (^)(id response, NSError *error, BOOL Success))getResponse;

@end
