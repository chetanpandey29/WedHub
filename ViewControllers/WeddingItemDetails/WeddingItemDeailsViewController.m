//
//  WeddingItemDeailsViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "WeddingItemDeailsViewController.h"
#import "QMApi.h"
#import "QMChatVC.h"
#import "QMViewControllersFactory.h"
#import "LoginViewController.h"
@interface WeddingItemDeailsViewController ()
{
    UITapGestureRecognizer *tapGesture1 ;
    UIImageView *img;
    NSMutableArray *selectedBlobidArray;
}
@end

@implementation WeddingItemDeailsViewController
@synthesize ratingView,imgBackground,imgProfileImage,vwPhotos,vwVideos,CollectionView,constCollectionViewHeight,arrVendorDetail,lblCity,lblName,lblReview,lblPriceRange,lblDescription,lblReviewCount,lblCategory,imgVideoArrow,imgPhotoArrow;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ratingView.backgroundColor  = [UIColor whiteColor];
    ratingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.maxRating = 5.0;
    ratingView.delegate = self;
    ratingView.editable=NO;
    ratingView.tintColor = [UIColor colorWithRed:222.0/255.0 green:140.0/255.0 blue:35.0/255.0 alpha:1.0];
    if([[arrVendorDetail valueForKey:@"user"] count]>0)
    {
        ratingView.rating=[[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"rating"] floatValue];
    }
    ratingView.displayMode=EDStarRatingDisplayHalf;
    
    imgProfileImage.layer.cornerRadius= imgProfileImage.frame.size.height/2;
    imgProfileImage.layer.borderColor=[UIColor whiteColor].CGColor;
    imgProfileImage.layer.borderWidth=2.0;
    imgProfileImage.image=[UIImage imageNamed:@"placeholder_image"];
    imgProfileImage.clipsToBounds = YES;
    if([[arrVendorDetail valueForKey:@"user"] count]>0)
    {
        if(![[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Image"] isKindOfClass:[NSNull class]] && ![[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Image"] isEqualToString:@""])
        {
            NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Image"] ];
            [imgProfileImage sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
        }
        
        NSString *stPrice = [NSString stringWithFormat:@"$%@-$%@",[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"MinPrice"],[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"MaxPrice"]];
        lblPriceRange.text=[NSString stringWithFormat: @"Price Range: %@",stPrice ];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:lblPriceRange.text];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor lightGrayColor] range: NSMakeRange(0, 12)];
        [text addAttribute: NSForegroundColorAttributeName value: AppColor range: NSMakeRange(13, stPrice.length)];
        [lblPriceRange setAttributedText: text];
    }
    
    vwPhotos.layer.cornerRadius=vwPhotos.frame.size.height/2;
    
    UITapGestureRecognizer *tapGestureRecognizerPhotos = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnPhotoTapped:)];
    tapGestureRecognizerPhotos.numberOfTapsRequired = 1;
    [vwPhotos addGestureRecognizer:tapGestureRecognizerPhotos];
    vwPhotos.userInteractionEnabled = YES;
    imgPhotoArrow.hidden=NO;
    imgVideoArrow.hidden=YES;
    
    vwVideos.layer.cornerRadius=vwVideos.frame.size.height/2;
    
    
    UITapGestureRecognizer *tapGestureRecognizerVideos = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnVideoTapped:)];
    tapGestureRecognizerVideos.numberOfTapsRequired = 1;
    [vwVideos addGestureRecognizer:tapGestureRecognizerVideos];
    vwVideos.userInteractionEnabled = YES;
    vwPhotos.backgroundColor=AppColor;
    vwVideos.backgroundColor=[UIColor darkGrayColor];
    vwPhotos.tag=1;
    vwVideos.tag=0;
    if([[arrVendorDetail valueForKey:@"user"] count]>0)
    {
        lblName.text=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Name"];
        lblCity.text=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"locationName"];
        
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%ld reviews)",(unsigned long)[[arrVendorDetail valueForKey:@"review"] count]]];
        [text1 addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, text1.length)];
        lblReview.attributedText = text1;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ReviewTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [lblReview addGestureRecognizer:tapGestureRecognizer];
        lblReview.userInteractionEnabled = YES;
        
        lblCategory.text=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Name1"];
        lblCategory.textColor=AppColor;
        
        lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        lblDescription.numberOfLines = 0; // limits to 5 lines; use 0 for unlimited.
        
        // self here is the parent view
        
        lblDescription.preferredMaxLayoutWidth = lblDescription.frame.size.width; // assumes the parent view has its frame already set.
        
        lblDescription.text = [[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"ShortBio"];
        [lblDescription sizeToFit];
        [lblDescription setNeedsDisplay];
        
        
        selectedBlobidArray  = [NSMutableArray arrayWithObjects:[[[arrVendorDetail valueForKey:@"user"] valueForKey:@"BlobId"] objectAtIndex:0], nil];
    }
    
}
-(void)btnPhotoTapped :(UITapGestureRecognizer *)tap
{
    imgPhotoArrow.hidden=NO;
    imgVideoArrow.hidden=YES;
    vwPhotos.backgroundColor = AppColor;
    vwPhotos.tag=1;
    vwVideos.tag=0;
    vwVideos.backgroundColor = [UIColor darkGrayColor];
    constCollectionViewHeight.constant=190;
    [CollectionView reloadData];
}
-(void)btnVideoTapped :(UITapGestureRecognizer *)tap
{
    imgPhotoArrow.hidden=YES;
    imgVideoArrow.hidden=NO;
    vwPhotos.backgroundColor = [UIColor darkGrayColor];
    vwVideos.tag=1;
    vwPhotos.tag=0;
    vwVideos.backgroundColor = AppColor;
    constCollectionViewHeight.constant=95;
    [CollectionView reloadData];
}

-(void)ReviewTapped :(UITapGestureRecognizer *)tap
{
    ReviewViewController *objReviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    objReviewViewController.arrReview=[arrVendorDetail valueForKey:@"review"];
    [AppUtilsShared setPreferences:[[[arrVendorDetail valueForKey:@"user"]objectAtIndex:0] valueForKey:@"Email"] withKey:@"VendorEmail"];
    [AppUtilsShared setPreferences:[[[arrVendorDetail valueForKey:@"user"]objectAtIndex:0] valueForKey:@"CategoryId"] withKey:@"VendorCategoryId"];

    
 objReviewViewController.strUserType=[AppUtilsShared getPreferences:@"UserType"];
    [self.navigationController pushViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     :objReviewViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSideMenu:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}
#pragma mark - CollectionView Delegate methods
#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(vwPhotos.tag==1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    img = (UIImageView *)[cell viewWithTag:100];
     img.image = [UIImage imageNamed:@"placeholder_image"];
    UIImageView *imgPlay = (UIImageView *)[cell viewWithTag:101];
    img.clipsToBounds=YES;
    
    img.userInteractionEnabled = YES;
    
    tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tap:)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [img addGestureRecognizer:tapGesture1];
    
    cell.backgroundColor=[UIColor clearColor];
    collectionView.backgroundColor = [UIColor clearColor];
    if(vwPhotos.tag==1)
    {
        imgPlay.hidden=YES;
         if([[arrVendorDetail valueForKey:@"image"] count]>0)
        {
            
            if(indexPath.section==0)
            {
                int index=(int)indexPath.row+1;
                for (int i=0; i<[[arrVendorDetail valueForKey:@"image"] count]; i++) {
                    if(index==[[[[arrVendorDetail valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Sequence_no"]integerValue])
                    {
                        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[arrVendorDetail valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Orignal_path"] ];
                        [img sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
                        break;
                    }
                    else
                    {
                        img.image = [UIImage imageNamed:@"placeholder_image"];
                    }
                    
                }
                
            }
            else
            {
                 int index=(int)indexPath.row+4;
                for (int i=0; i<[[arrVendorDetail valueForKey:@"image"] count]; i++) {
                    if(index==[[[[arrVendorDetail valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Sequence_no"]integerValue])
                    {
                        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[arrVendorDetail valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Orignal_path"] ];
                        [img sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
                        break;
                    }
                    else
                    {
                        img.image = [UIImage imageNamed:@"placeholder_image"];
                    }
                    
                }
            }
        }
    }
    else
    {
        imgPlay.hidden=NO;
        [imgPlay setImage:[UIImage imageNamed:@"PlayButton"]];
        int index=(int)indexPath.row;
        if(index<[[arrVendorDetail valueForKey:@"video"] count])
        {
            if([[[[arrVendorDetail valueForKey:@"video"] objectAtIndex:indexPath.row] valueForKey:@"Video_path"] isEqualToString:@""] || arrVendorDetail.count<=0)
            {
                img.image = [UIImage imageNamed:@"placeholder_image"];
            }
            else
            { NSString *VedioURL=[[[arrVendorDetail valueForKey:@"video"] objectAtIndex:indexPath.row] valueForKey:@"Video_path"];
                
                
                NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
                NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:nil];
                
                NSArray *array = [regExp matchesInString:VedioURL options:0 range:NSMakeRange(0,VedioURL.length)];
                if (array.count > 0) {
                    NSTextCheckingResult *result = array.firstObject;
                    NSString *strVedioId= [VedioURL substringWithRange:result.range];
                    NSString *strThumbURL=[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",strVedioId];
                    
                    [img sd_setImageWithURL:[NSURL URLWithString:strThumbURL] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
                }
                

            }
        }
        else
        {
            img.image = [UIImage imageNamed:@"placeholder_image"];
        }
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    
    CGSize size = CGSizeMake(cellWidth,cellWidth-25);
    return size;
}


-(void)tap :(UITapGestureRecognizer *)imageview
{
    CGPoint p = [imageview locationInView:CollectionView];
    NSIndexPath *indexSelectedImage=[CollectionView indexPathForItemAtPoint:p];
    if(vwPhotos.tag==1)
    {
        UICollectionViewCell *cell=(UICollectionViewCell *)[CollectionView cellForItemAtIndexPath:indexSelectedImage];
        img = (UIImageView *)[cell viewWithTag:100];
        if (![[UIImage imageNamed:@"placeholder_image"]  isEqual:img.image])
        {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
   
   
    UIImage *image = img.image;
    imageInfo.image =image;
    imageInfo.referenceRect = img.frame;
    imageInfo.referenceView = img.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        }
        else
        {
            [AppUtilsShared ShowNotificationwithMessage:@"No image is uploaded." withcolor:REDCOLOR];
        }

    }
    else
    {
        UICollectionViewCell *cell=(UICollectionViewCell *)[CollectionView cellForItemAtIndexPath:indexSelectedImage];
        img = (UIImageView *)[cell viewWithTag:100];
        UIImage *image = img.image;
        if (![[UIImage imageNamed:@"placeholder_image"]  isEqual:image])
        {
            
            
            NSString *VedioURL=[[[arrVendorDetail valueForKey:@"video"] objectAtIndex:indexSelectedImage.row] valueForKey:@"Video_path"];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",VedioURL]]];

    }
        
        else
            
        {
            [AppUtilsShared ShowNotificationwithMessage:@"No video is uploaded." withcolor:REDCOLOR];
        }
        

    }
}


- (IBAction)btnFacebook:(id)sender {
    NSString *strFacebookId=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"FaceBook"];
    if(![strFacebookId isKindOfClass:[NSNull class]] && ![strFacebookId isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strFacebookId]]];
    }
    else
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Not available for this vendor." withcolor:REDCOLOR];
    }

}
- (IBAction)btnTwitter:(id)sender {
    NSString *strTwitterId=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Twitter"];
    if(![strTwitterId isKindOfClass:[NSNull class]] && ![strTwitterId isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strTwitterId]]];
    }
    else
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Not available for this vendor." withcolor:REDCOLOR];
    }

}
- (IBAction)btnInstagram:(id)sender {
    NSString *strInstagramId=[[[arrVendorDetail valueForKey:@"user"] objectAtIndex:0]valueForKey:@"Instagram"];
    if(![strInstagramId isKindOfClass:[NSNull class]] && ![strInstagramId isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strInstagramId]]];
    }
    else
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Not available for this vendor." withcolor:REDCOLOR];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)connectToChat
{
    [SVProgressHUD show];
    
    [[QMApi instance] loginWithEmail:[AppUtilsShared getPreferences:@"Emailid"] password:@"admin@123" rememberMe:YES completion:^(BOOL success)
     {
         
         if (success)
         {
             
             
    [[QMApi instance] connectChat:^(BOOL loginSuccess) {
        
    
        
        QBUUser *usr = [QMApi instance].currentUser;
        if (!usr.isImport) {
            self.importGroup = dispatch_group_create();
            
            dispatch_group_notify(self.importGroup, dispatch_get_main_queue(), ^{
                
                usr.isImport = YES;
                
                QBUpdateUserParameters *params = [QBUpdateUserParameters new];
                params.customData = usr.customData;
                
                [[QMApi instance] updateCurrentUser:params image:nil progress:nil completion:^(BOOL success) {
                    
                    if (QMApi.instance.currentUser) {
                        
                        [self CreatNewChat];
                        
                    }
                }];
            });
        }
        else
        {
            
            if (QMApi.instance.currentUser) {
                
                [self CreatNewChat];
                
            }
        }
        // open chat if app was launched by push notifications
        NSDictionary *push = [[QMApi instance] pushNotification];
        
        if (push != nil) {
            if( push[kPushNotificationDialogIDKey] ){
                
            }
        }
        
        [[QMApi instance] fetchAllData:nil];
    }];
         }
     }];
}
- (IBAction)btnChatClick:(id)sender {
    if([[AppUtilsShared getPreferences:@"UserType"]isEqualToString:@"Vendor"])
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Vendor cannot chat with vendor." withcolor:REDCOLOR];
        
    }
    else{
        if([[AppUtilsShared getPreferences:@"autoLogin"]isEqualToString:@"YES"])
        {
            [self connectToChat];
        }
        else
        {
            LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:objLoginViewController animated:YES];
        }
    }
    
    
    
}
-(void)CreatNewChat
{
//    [[QMApi instance] loginWithEmail:[AppUtilsShared getPreferences:@"Emailid"] password:@"admin@123" rememberMe:YES completion:^(BOOL success)
//     {
//         if (success)
//         {
    [SVProgressHUD show];
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
    
    [QBRequest dialogsForPage:page extendedRequest:nil successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        
        for (int f=0; f<dialogObjects.count; f++) {
            
            
            
            NSMutableArray *arrtemp = [[dialogObjects objectAtIndex:f] valueForKey:@"occupantIDs"];
            
            NSString *str = [NSString stringWithFormat:@"%@",[selectedBlobidArray objectAtIndex:0]];
            
            
            if ([arrtemp containsObject:[NSNumber numberWithInteger: [str integerValue]]]&&arrtemp.count==2) {
                
                
                QBChatDialog *dialog = dialogObjects[f];
                
                UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                
                QMChatVC *objChat = [objStoryboard instantiateViewControllerWithIdentifier:@"QMChatVC"];
                
                objChat.dialog = dialog;
                [SVProgressHUD dismiss];
                
                [self.navigationController pushViewController:objChat animated:YES];
                return ;
                
            }
        }
        
        [SVProgressHUD showWithStatus:@"Loading Chat..." maskType:SVProgressHUDMaskTypeClear];
        
        QBChatDialog *chatDialog = [[QBChatDialog alloc] initWithDialogID:nil type:QBChatDialogTypeGroup];
        chatDialog.name = @"Chat with Bob";
        // chatDialog.photo = @"jaimin";
        
        
        
        
        
        
        NSNumber *firstNumber = [selectedBlobidArray objectAtIndex:0];
        NSInteger valueOfFirstNumber = [firstNumber integerValue];
        
        __block    NSString *chatName;
        __block    NSString *userImage;
        
        chatDialog.occupantIDs = @[@(valueOfFirstNumber)];
        
        //    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        __weak __typeof(self)weakSelf = self;
        
        
        [SVProgressHUD showWithStatus:@"Loading Chat......" maskType:SVProgressHUDMaskTypeClear];
        
        [QBRequest usersWithIDs:selectedBlobidArray page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
            
            
            
            
            chatName = [self chatNameFromUserNames:users];
            
            
            
            chatName.accessibilityValue=lblCategory.text;
            
            
            
            [[QMApi instance] createGroupChatDialogWithName:chatName occupants:selectedBlobidArray completion:^(QBChatDialog *chatDialog) {
                
                
                if (chatDialog != nil) {
                    
                    // chatDialog.ID.accessibilityElements= self.dicCustomerData;//comment
                    
                    
                    UIViewController *chatVC = [QMViewControllersFactory chatControllerWithDialogID:chatDialog.ID];
                    
                    
                    NSMutableArray *controllers = weakSelf.navigationController.viewControllers.mutableCopy;
                    
                    [controllers removeLastObject];
                    
                    [controllers addObject:chatVC];
                    
                    [SVProgressHUD dismiss];
                    [weakSelf.navigationController setViewControllers:controllers animated:YES];
                    
                }
                
                [SVProgressHUD dismiss];
                
            }];
            // Successful response with page information and users array
        } errorBlock:^(QBResponse *response) {
            // Handle error here
        }];
        
    } errorBlock:^(QBResponse *response) {
        
    }];
    
       //  }}];
}
- (NSString *)chatNameFromUserNames:(NSMutableArray *)users {
    
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:users.count];
    
    for (QBUUser *user in users) {
        [names addObject:user.fullName];
    }
    if (users.count>1) {
        [names addObject:[QMApi instance].currentUser.fullName];
    }
    
    return [names componentsJoinedByString:@", "];
}
@end
