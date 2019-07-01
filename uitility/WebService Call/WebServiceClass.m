//
//  WebServiceClass.m
//  StartUp
//
//  Created by Kunj Patel on 6/17/15.
//  Copyright (c) 2015 Kunj Patel. All rights reserved.
//

#import "WebServiceClass.h"
#import "STHTTPRequest.h"
#import "Constant.h"
#import "SBJson.h"


@implementation WebServiceClass

+ (id)werserviceSharedManager {
    
    static WebServiceClass *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


-(void)postRequestWithUrl:(NSString *)strURL andParameters:(NSData *)mParameters showLoader:(BOOL)isLoader response:(void (^)(id response, NSError *error, BOOL Success))getResponse;
{
    if (isLoader)
    {
        
    [Delegate showLoader];
        
    }
    
    if (![Delegate checkInternetConnection]) {
        getResponse(nil,nil,NO);
        [Delegate hideLoader];
        return;
    }
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",strURL]];
    r.HTTPMethod = @"POST";
    [r setHeaderWithName:@"content-type" value:@"application/json; charset=utf-8"];

    
    r.rawPOSTData = mParameters;

    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        @try {
           
            body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            body = [body stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            body = [body stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
            body = [body stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            body = [body stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
            body = [body stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];

            
            
            [Delegate hideLoader];
            id response = [body JSONValue];
           
            if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 1) {
                getResponse(response,nil,YES);
            }
            else if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 2) {
                getResponse(response,nil,YES);
            }
           
            else if ([response valueForKey:@"message"] &&  [[response valueForKey:@"message"] length] > 0) {
                [AppUtilsShared ShowNotificationwithMessage:[response valueForKey:@"message"] withcolor:REDCOLOR];
            }
         
            
            
            else{
               getResponse(nil,nil,NO);
            }
            
            

            
         
        }
        @catch (NSException *exception) {
            getResponse(nil,nil,NO);
            [Delegate hideLoader];
        }
        
        // [Delegate hideLoader];
       
    };
    
    r.errorBlock = ^(NSError *error) {
        if(error.code == -1005)
        {
            [self postRequestWithUrl:strURL andParameters:mParameters  showLoader:isLoader response:^(id response, NSError *error, BOOL Success) {
                if (Success) {
                     getResponse(response,nil,YES);
                }
                else
                {
                    getResponse(nil,nil,NO);
                }
                
            }];
            return ;
        }
        NSLog(@"%@",error.description);
        [Delegate hideLoader];
       getResponse(nil,error,NO);
    };
    [r startAsynchronous];
}


-(void)getRequestWithUrl:(NSString *)strURL showLoader:(BOOL)isLoader response:(void (^)(id response, NSError *error, BOOL Success))getResponse;
{
    if (isLoader) {
        
        [Delegate showLoader];
        
    }
    
    if (![Delegate checkInternetConnection]) {
        getResponse(nil,nil,NO);
        [Delegate hideLoader];
        return;
    }
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    r.HTTPMethod = @"GET";
    
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
       
        
        @try {
       

        body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        body = [body stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        body = [body stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        body = [body stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        body = [body stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
        body = [body stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
        
      
        id response = [body JSONValue];
          [Delegate hideLoader];
            if ([response isKindOfClass:[NSMutableArray class]]) {
                getResponse(response,nil,YES);
            }
           
            else if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 1) {
                getResponse(response,nil,YES);
            }
            else if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 2) {
                getResponse(response,nil,YES);
            }
            else if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 0) {
                [AppUtilsShared ShowNotificationwithMessage:[response valueForKey:@"message"] withcolor:REDCOLOR];
                
                getResponse(nil,nil,NO);
            }
            
            else if ([response valueForKey:@"message"] &&  [[response valueForKey:@"message"] length] > 0) {
                [AppUtilsShared ShowNotificationwithMessage:[response valueForKey:@"message"] withcolor:REDCOLOR];
            }
            
            else{
                getResponse(nil,nil,NO);
            }

            
        }
        @catch (NSException *exception) {
            getResponse(nil,nil,NO);
            [Delegate hideLoader];
        }
        
    };
    r.errorBlock = ^(NSError *error) {
        if(error.code == -1005)
        {
            [self getRequestWithUrl:strURL showLoader:isLoader response:^(id response, NSError *error, BOOL Success) {
                if (Success) {
                    getResponse(response,nil,YES);
                }
                else
                {
                    getResponse(nil,nil,NO);
                }
                
            }];
            return ;
        }
        NSLog(@"%@",error.description);
        [Delegate hideLoader];
        getResponse(nil,error,NO);
    };
    [r startAsynchronous];
}






@end
