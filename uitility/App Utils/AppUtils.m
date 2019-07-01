
//
//  AppUtils.m
//  Situ
//
//  Created by Kunj Patel on 29/06/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.
//

#import "AppUtils.h"
#import "UIView+Toast.h"



@implementation AppUtils


#pragma mark -
#pragma mark ClASS SETUP
#pragma mark -

+ (AppUtils *)sharedInstance {
    static AppUtils  *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AppUtils alloc] init];
    });
    return _sharedInstance;
}

- (id) init
{
    return self;
}

-(BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];
}

-(NSString *)validateMobileandSetText :(NSString *)stMobileNo
{
    
    
    if (stMobileNo!=nil && stMobileNo.length>0 && ![stMobileNo isEqualToString:@""]) {
        
        NSString *MobileNoRegEx = @"^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$";
        NSPredicate *MobileNoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MobileNoRegEx];
        
        BOOL IsValidMoNumber= [MobileNoTest evaluateWithObject:stMobileNo];
        
        //Check for +91 prefix, if found than remove
        
        if (IsValidMoNumber && stMobileNo.length>10 && [stMobileNo hasPrefix:@"+91"] )
        {
            
            stMobileNo=[stMobileNo stringByReplacingOccurrencesOfString:@"+91" withString:@""];
            
            return stMobileNo;
            
        }
        else if (IsValidMoNumber && stMobileNo.length>10 && [stMobileNo hasPrefix:@"91"] )
        {
            
            stMobileNo=[stMobileNo substringFromIndex:2];
            
            return stMobileNo;
            
        }
        else if (IsValidMoNumber && stMobileNo.length>10 && [stMobileNo hasPrefix:@"0"] )
        {
            
            stMobileNo=[stMobileNo substringFromIndex:1];
            
            return stMobileNo;
        }
        else if(IsValidMoNumber)
        {
            
            return stMobileNo;
        }
        else if([stMobileNo containsString:@"-"])
        {
            stMobileNo= [stMobileNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            return stMobileNo;
        }
        else
        {
            
            [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Valid Mobile Number!" withcolor:REDCOLOR];
        }
        
    }
    else{
        
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Valid 10 Digit Number!" withcolor:REDCOLOR];
        
        return nil;
    }
    
    
    return nil;
    
    
    
}
#pragma mark -
#pragma mark Navigation Items
#pragma mark -

-(UIBarButtonItem *)getNavigationBackButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [backBtn setTintColor:[UIColor whiteColor]];
    
    if (![imageName isEqualToString:@""]) {
        
        UIImage *backBtnImage = [UIImage imageNamed:imageName]  ;
        [backBtn setImage:backBtnImage forState:UIControlStateNormal];
        [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    }
    
    [backBtn addTarget:controler action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    return backButton;
}

-(UIBarButtonItem *)getNavigationButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector{
    
    
    UIButton *btnNavigation = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 44.0f)];
    
    [btnNavigation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIImage *imgNavigationButton = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    btnNavigation.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    
    [btnNavigation setImage:imgNavigationButton forState:UIControlStateNormal];
    [btnNavigation addTarget:controler action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnNavigation];
    
    return backButtonItem1;
}

-(UIBarButtonItem *)getCancleButton:(NSString *) imageName conroler:(UIViewController *)controler selectorName:(SEL)selector{
    
    
    UIButton *btnNavigation = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 44.0f)];
    [btnNavigation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btnNavigation.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    
    [btnNavigation setTitle:imageName forState:UIControlStateNormal];
    
    // [btnNavigation.titleLabel setFont:FONT_WITH_SIZE(Trebuchet_MS,FONT_SIZE_13)];
    [btnNavigation addTarget:controler action:selector forControlEvents:UIControlEventTouchUpInside];
    [btnNavigation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnNavigation];
    
    return backButtonItem1;
}


-(UILabel *)getNavigationTitle:(NSString *)strTitle {
    
    UILabel * lblNavigation = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];

    if (IS_IPHONE_4 || IS_IPHONE_5) {
        
        lblNavigation.frame = CGRectMake(0, 0, 320, 70);
    }
    if(IS_IPHONE_6) {
        
        lblNavigation.frame = CGRectMake(0, 0, 500, 35);
        
    } else {
        
        lblNavigation.frame = CGRectMake(0, 0, 700, 35);
    }
   
    [lblNavigation setText:strTitle];
    [lblNavigation setBackgroundColor:[UIColor clearColor]];
    UIFont* boldFont = [UIFont boldSystemFontOfSize:19];
    [lblNavigation setFont:boldFont];
    lblNavigation.textColor = [UIColor whiteColor];
    [lblNavigation setTextAlignment:NSTextAlignmentCenter];
    float width = self.view.bounds.size.width;
    float height =self.view.bounds.size.height;
    [lblNavigation setFrame:CGRectMake(width-100,height-100, 100, 100)];
    return lblNavigation;
}


#pragma mark Show Notification
-(void)ShowNotificationwithMessage:(NSString *)message withcolor:(UIColor *)color
{
   
    if (!message) {
        message = @"";
    }
    [CRToastManager dismissNotification:NO];
    NSMutableDictionary *options = [@{
                                      kCRToastFontKey:[UIFont systemFontOfSize:17],
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                      kCRToastTextKey : message,
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : color,
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom)
                                      } mutableCopy];
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                  automaticallyDismiss:YES
                                                                                                                 block:^(CRToastInteractionType interactionType){
                                                                                                                     NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                                 }]];
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
}




#pragma mark -
#pragma mark Set and Get Preference Method
#pragma mark -

-(void)setPreferences:(id)value withKey:(NSString *)key{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [defaluts setObject:value forKey:key];
    [defaluts synchronize];
}

-(id)getPreferences:(NSString *)key{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    
    return [self setForNull:[defaluts objectForKey:key]];
}


-(BOOL)isPreferencesExist:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[[prefs dictionaryRepresentation] allKeys] containsObject:key]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)setPreferencesBOOL:(BOOL)value withKey:(NSString *)key{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [defaluts setBool:value forKey:key];
    [defaluts synchronize];
}

-(BOOL)getPreferencesBOOL:(NSString *)key{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    return [defaluts boolForKey:key];
}

-(void)deletePreference:(NSString *)key{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [defaluts removeObjectForKey:key];
    [defaluts synchronize];
    
}

-(void)clearAllPrefrences {
    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}




-(NSString *)setForNull:(NSString*)strText {
    //     && strText.length >0
    if([strText class] != [NSNull class] && strText != NULL){
        
        return strText;
    }
    else {
        return @"";
    }
}






#pragma mark -
#pragma mark COLOR CONVERT
#pragma mark -

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

-(UIImage *)imageFromColor:(UIColor *)color frame:(CGRect)rect1{
    
    CGRect rect = CGRectMake(0, 0, rect1.size.width, rect1.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


#pragma mark
#pragma mark - PopUp Animation
#pragma mark


- (void)animateViewHeight:(UIView*)animateView withAnimationType:(NSString*)animType {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:animType];
    
    [animation setDuration:0.7];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[animateView layer] addAnimation:animation forKey:kCATransition];
    animateView.hidden = !animateView.hidden;
    
}


#pragma mark
#pragma mark - device Id
#pragma mark

- (NSString *)deviceUUID
{
    if (IosVersiongreaterThan8) {
        
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
        @autoreleasepool
    {
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
        
    }
    else
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
}

-(void)setTextBoxBoarder : (UITextField *)textfield{
    
    textfield.layer.cornerRadius = textfield.frame.size.height/2;
    textfield.layer.borderColor = TextFieldBoarderColor;
    textfield.layer.borderWidth =0.5;
   
}
-(void)setTextviewBoarder : (UITextView *)textview
{
    
    textview.layer.cornerRadius = textview.frame.size.height/5;
    textview.layer.borderColor = TextFieldBoarderColor;
    textview.layer.borderWidth =0.5;
    
}
-(void)setButtonRadius : (UIButton *)button
{
    
    button.layer.cornerRadius = button.frame.size.height/2;
   
    
}
-(void)setPlaceHolderViewImage :(UITextField *)textfield : (NSString *)imgName :(NSString *)LeftOrRight
{
   
    
    if ([LeftOrRight isEqualToString:@"Left"]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8,(textfield.frame.size.height-20)/2, 20, 20)];
        imgView.image = [UIImage imageNamed:imgName];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 32, 32)];
        [paddingView addSubview:imgView];
        textfield.leftViewMode = UITextFieldViewModeAlways;
         [textfield setLeftView:paddingView];
     
    }
    else
    {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(textfield.frame.size.height-20)/2, 20, 20)];
        imgView.image = [UIImage imageNamed:imgName];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, 5, 32, 32)];
        [paddingView addSubview:imgView];
        textfield.rightViewMode = UITextFieldViewModeAlways;
          [textfield setRightView:paddingView];
       
    }
   

  //  textfield.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
 
}
@end
