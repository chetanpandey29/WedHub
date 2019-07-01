//
//  MyProfileViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 23/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "MyProfileViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "WeddingItemDeailsViewController.h"
#import "SVProgressHUD.h"
@interface MyProfileViewController ()
{
    NSMutableDictionary *dictProfileData;
    UIImage *cellImage;
    NSIndexPath *indexSelectedImage;
    UIButton *btnTransperencyButton;
    NSString *strCategoryId,*strLocationId,*strProfilePicPath,*strVendorId;
}

@end

@implementation MyProfileViewController
@synthesize txtName,txtContactNo,txtEmail,txtFacebook,txtConfirmPassword,txtInstagram,txtPassword,txtSnapChat,txtTwitter,vwPhotos,vwVideos,btnUpdateProfile,tvShortBio,imgProfilePic,imgCamera,constCollectionViewHeight,txtCategory,txtLocation,txtMaxPrice,txtMinPrice,txtMobileNo,URLView,txtInsertURL,btnSubmit,btnCancel,constCategoryTop,constMaxPriceTop,constMinPriceTop,constPhotosTop,constVideosTop,constTwitterTop,constFacebookTop,constSnapchatTop,constInstagramTop,constPhotosHeight,constTwitterHeight,constFacebookHeight,constSnapchatHeight,constInstagramHeight,constCollectionViewTopWithVideo,constCollectionViewTopWithPhotos,constMaxHeight,constMinHeight,constCategoryHeight,imgPhotoArrow,imgVideoArrow,lblProfileURL,btnCopyURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dictProfileData=[[NSMutableDictionary alloc]init];
    vwPhotos.backgroundColor=AppColor;
    vwVideos.backgroundColor=[UIColor darkGrayColor];
    
    UITapGestureRecognizer *vwVideosTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VideoTapHandler:)];
    [vwVideos addGestureRecognizer:vwVideosTap];
    vwPhotos.tag=1;
    vwVideos.tag=0;
    imgProfilePic.tag=1;
    imgPhotoArrow.hidden=NO;
    imgVideoArrow.hidden=YES;
    
    UITapGestureRecognizer *vwPhotosTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhotoTapHandler:)];
    [vwPhotos addGestureRecognizer:vwPhotosTap];
    
    
    
    btnUpdateProfile.backgroundColor= AppColor;
   
    self.collectionView.backgroundColor= [UIColor clearColor];
    
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"My Profile"];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    [self setBoarder];
    imgProfilePic.image=[UIImage imageNamed:@"placeholder_image"];
    
    UITapGestureRecognizer *tapCamera = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(UploadProfilePic:)];
    [imgProfilePic addGestureRecognizer:tapCamera];
    [imgProfilePic setMultipleTouchEnabled:YES];
    [imgProfilePic setUserInteractionEnabled:YES];
   
    [self callGetProfileService];
    


    URLView.hidden=YES;
    btnSubmit.backgroundColor=AppColor;
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnCancel.backgroundColor=[UIColor grayColor];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
      
 lblProfileURL.userInteractionEnabled=YES;
    
    
    UITapGestureRecognizer *lblProfileURLGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(URLTap:)];
    [lblProfileURL addGestureRecognizer:lblProfileURLGesture];
   
    
}
-(void)PhotoTapHandler:(UIGestureRecognizer *)gestureRecognizer
{
    imgPhotoArrow.hidden=NO;
    imgVideoArrow.hidden=YES;
    vwPhotos.backgroundColor = AppColor;
    vwPhotos.tag=1;
    vwVideos.tag=0;
    vwVideos.backgroundColor = [UIColor darkGrayColor];
     constCollectionViewHeight.constant=184;
    [_collectionView reloadData];
}
-(void)VideoTapHandler:(UIGestureRecognizer *)gestureRecognizer
{
    imgPhotoArrow.hidden=YES;
    imgVideoArrow.hidden=NO;
     vwPhotos.backgroundColor = [UIColor darkGrayColor];
    vwVideos.tag=1;
    vwPhotos.tag=0;
     vwVideos.backgroundColor = AppColor;
     constCollectionViewHeight.constant=87;
    [_collectionView reloadData];
 
}
-(void)URLTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *strURL=[NSString stringWithFormat:@"%@",[lblProfileURL.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSURL *url = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)dismissHelper:(id)sender
{
    URLView.hidden=YES;
    btnTransperencyButton.hidden=YES;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (cell.selected) {
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:153/255.0 alpha:1]; // highlight selection
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor]; // Default color
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
   // longPress.minimumPressDuration = 2.0; //seconds
    
    [cell addGestureRecognizer:longPress];
    UIImageView *img = (UIImageView *)[cell viewWithTag:100];
    UIImageView *imgPlay = (UIImageView *)[cell viewWithTag:101];
    UIButton *btnBackground=(UIButton *)[cell viewWithTag:102];
     img.image = [UIImage imageNamed:@"placeholder_image"];
    btnBackground.hidden=YES;
    if(vwPhotos.tag==1)
    {
        imgPlay.hidden=YES;
        
        if([[dictProfileData valueForKey:@"image"] count]>0)
        {
            
            if(indexPath.section==0)
            {
                int index=(int)indexPath.row+1;
                for (int i=0; i<[[dictProfileData valueForKey:@"image"] count]; i++) {
                    if(index==[[[[dictProfileData valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Sequence_no"]integerValue])
                    {
                        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[dictProfileData valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Orignal_path"] ];
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
                for (int i=0; i<[[dictProfileData valueForKey:@"image"] count]; i++) {
                    if(index==[[[[dictProfileData valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Sequence_no"]integerValue])
                    {
                        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[dictProfileData valueForKey:@"image"] objectAtIndex:i]valueForKey:@"Orignal_path"] ];
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
        if(index<[[dictProfileData valueForKey:@"video"] count])
        {
            if([[[[dictProfileData valueForKey:@"video"] objectAtIndex:indexPath.row] valueForKey:@"Video_path"] isEqualToString:@""] || dictProfileData.count<=0)
            {
                img.image = [UIImage imageNamed:@"placeholder_image"];
            }
            else
            {
                
                NSString *VedioURL=[[[dictProfileData valueForKey:@"video"] objectAtIndex:indexPath.row] valueForKey:@"Video_path"];
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
    cell.backgroundColor=[UIColor clearColor];

    return cell;
}
- (UIImage *)generateThumbnailIconForVideoFileWith:(NSURL *)contentURL
{
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    return one;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(vwPhotos.tag==1)
    {
      
    imgProfilePic.tag=0;
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
       
        indexSelectedImage=indexPath;
    UIImageView *img = (UIImageView *)[cell viewWithTag:100];
    UIImage *image = img.image;
               if ([[UIImage imageNamed:@"placeholder_image"]  isEqual:image])
    {
//        btnBackground.hidden=YES;
//        imgPlay.hidden=YES;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                         delegate: self
                                                                cancelButtonTitle: @"Cancel"
                                                           destructiveButtonTitle: nil
                                                                otherButtonTitles: @"Take a new photo",
                                              @"Choose from existing", nil];
        [actionSheet showInView:self.view];
       
    }
    else
    {
//        btnBackground.hidden=YES;
//        imgPlay.hidden=YES;
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = image;
      
        
        // Setup view controller
        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                               initWithImageInfo:imageInfo
                                               mode:JTSImageViewControllerMode_Image
                                               backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
        
        // Present the view controller.
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        
    }
    }
    else
    {
        UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *img = (UIImageView *)[cell viewWithTag:100];
        UIImage *image = img.image;
        if (![[UIImage imageNamed:@"placeholder_image"]  isEqual:image])
        {
            NSString *VedioURL=[[[dictProfileData valueForKey:@"video"] objectAtIndex:indexPath.row] valueForKey:@"Video_path"];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",VedioURL]]];
        
        }
        else
        {
            
                btnTransperencyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                btnTransperencyButton.backgroundColor = [UIColor blackColor];
            btnTransperencyButton.alpha=0.6;
                [btnTransperencyButton addTarget:self action:@selector(dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
                [self.view insertSubview:btnTransperencyButton belowSubview:URLView];
             URLView.hidden=NO;
        }
    }
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

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
    if(vwPhotos.tag==1)
    {
      
        if ( gesture.state == UIGestureRecognizerStateEnded )
        {
        
            CGPoint p = [gesture locationInView:self.collectionView];
            indexSelectedImage=[self.collectionView indexPathForItemAtPoint:p];
            UICollectionViewCell *cell=(UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexSelectedImage];
            UIImageView *img = (UIImageView *)[cell viewWithTag:100];
            UIImage *image = img.image;
           
            
            
//            btnBackground.hidden=NO;
            if (![[UIImage imageNamed:@"placeholder_image"]  isEqual:image])
            {
                UIButton *btnBackground=(UIButton *)[cell viewWithTag:102];
                btnBackground.hidden=NO;
                btnBackground.backgroundColor=[UIColor blackColor];
                btnBackground.alpha=0.5;
                UIImageView *imgPlay = (UIImageView *)[cell viewWithTag:101];
                [imgPlay setImage:[UIImage imageNamed:@"Delete"]];
                imgPlay.hidden=NO;

                UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Delete"
                                    message:@"Are You Sure You Want To Delete Image?"
                                    delegate:self
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:@"Ok",nil];
           
            [myAlert show];
                btnBackground.hidden=YES;
                imgPlay.hidden=YES;
            }
            else
            {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                     delegate: self
                                                            cancelButtonTitle: @"Cancel"
                                                       destructiveButtonTitle: nil
                                                            otherButtonTitles: @"Take a new photo",
                                          @"Choose from existing", nil];
            [actionSheet showInView:self.view];
            }
        }
    }
    else
    {
        if ( gesture.state == UIGestureRecognizerStateEnded )
        {
            
            CGPoint p = [gesture locationInView:self.collectionView];
            indexSelectedImage=[self.collectionView indexPathForItemAtPoint:p];
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Delete"
                                    message:@"Are You Sure You Want To Delete Image?"
                                    delegate:self
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:@"Ok",nil];
            
            [myAlert show];
            
        }

    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
    }
    else
    {
        if(vwPhotos.tag==1)
        {
            [self callDeleteImage];
        }
        else
        {
            [self callDeleteVedio];
        }
    }
}
-(void)setBoarder
{
    [AppUtilsShared setTextBoxBoarder:txtName];
    
    [AppUtilsShared setTextBoxBoarder:txtEmail];
    
    [AppUtilsShared setTextBoxBoarder:txtPassword];
    
    [AppUtilsShared setTextBoxBoarder:txtConfirmPassword];
    
    [AppUtilsShared setTextBoxBoarder:txtContactNo];
    
    [AppUtilsShared setTextBoxBoarder:txtMobileNo];
    
    [AppUtilsShared setTextBoxBoarder:txtFacebook];
    
    [AppUtilsShared setTextBoxBoarder:txtInstagram];
    
    [AppUtilsShared setTextBoxBoarder:txtSnapChat];
    
    [AppUtilsShared setTextBoxBoarder:txtTwitter];
    
    [AppUtilsShared setTextBoxBoarder:txtCategory];
    
    [AppUtilsShared setTextBoxBoarder:txtMinPrice];
    
    [AppUtilsShared setTextBoxBoarder:txtMaxPrice];
    
    [AppUtilsShared setTextBoxBoarder:txtLocation];
    
    [AppUtilsShared setTextBoxBoarder:txtInsertURL];
    
    [AppUtilsShared setTextviewBoarder:tvShortBio];
   
    [AppUtilsShared setButtonRadius:btnUpdateProfile];
    
     [AppUtilsShared setButtonRadius:btnCancel];
    
     [AppUtilsShared setButtonRadius:btnSubmit];
    
    
    btnUpdateProfile.layer.borderColor = [UIColor clearColor].CGColor;
    btnUpdateProfile.layer.borderWidth =0.8;
    
    imgProfilePic.layer.cornerRadius =imgProfilePic.frame.size.height/2;
    imgProfilePic.clipsToBounds = YES;
    
    
    vwPhotos.layer.cornerRadius=vwPhotos.frame.size.height/2;
    
    vwVideos.layer.cornerRadius=vwVideos.frame.size.height/2;
    
    URLView.layer.cornerRadius=5;
    URLView.layer.borderColor=[UIColor clearColor].CGColor;
    URLView.layer.borderWidth=1.0;
    
    lblProfileURL.layer.cornerRadius=lblProfileURL.frame.size.height/2;
    lblProfileURL.layer.borderColor=[UIColor lightGrayColor].CGColor;
    lblProfileURL.layer.borderWidth=0.5;
    
    [AppUtilsShared setPlaceHolderViewImage:txtFacebook :@"Facebook":@"Left"];
    
    [AppUtilsShared setPlaceHolderViewImage:txtTwitter :@"Twitter":@"Left"];
    [AppUtilsShared setPlaceHolderViewImage:txtSnapChat :@"Snapchat":@"Left"];
    [AppUtilsShared setPlaceHolderViewImage:txtInstagram :@"Instagram":@"Left"];
    
    
}


#pragma mark - Capture Image
#pragma mark
-(void)UploadProfilePic :(UITapGestureRecognizer *)tap
{
     [self.view endEditing:YES];
    imgProfilePic.tag=1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo",
                                  @"Choose from existing", nil];
    [actionSheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger i = buttonIndex;
    
    switch(i) {
            
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
                
            }
            else
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = NO;
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.delegate = self;
            picker.allowsEditing = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:picker animated:YES completion:nil];
        }
            
        default:
            break;
    }
}

#pragma mark -PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}




-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image/video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
     UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    NSMutableURLRequest *request;
   
    if(imgProfilePic.tag==1)
    {
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:WEBSERVICEURL"GeneralWedHub/Postimage"]];
    }
        
    else
    {
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:WEBSERVICEURL"GeneralWedHub/Postphotos"]];
    }
    
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:300];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    
    if(imgProfilePic.tag==0)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"MemberId"] dataUsingEncoding:NSUTF8StringEncoding]];
   [body appendData:[[NSString stringWithFormat:@"%@\r\n", [AppUtilsShared getPreferences:@"MemberId"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"CategoryId"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",strCategoryId ] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"Sequence_no"] dataUsingEncoding:NSUTF8StringEncoding]];
        int index;
        if(indexSelectedImage.section==0)
        {
            index=(int)indexSelectedImage.row+1;
        }
        else
        {
            index=(int)indexSelectedImage.row+4;
        }
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", index] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"device"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",@"Iphone" ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
   
    
    // add image data
    NSString * timestamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if(imgProfilePic.tag==0)
        {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@.jpg\r\n", @"Image",timestamp] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@.jpg\r\n", @"image",timestamp] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            [Delegate hideLoader];
            NSString * stResponse = [[NSString alloc] initWithData:data
                                                          encoding:NSUTF8StringEncoding];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
            stResponse = [stResponse stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
            
            
            
            NSLog(@"response%@",response);
            
            id response = [stResponse JSONValue];
            if ([response valueForKey:@"status"] &&  [[response valueForKey:@"status"] integerValue] == 1) {
                if(imgProfilePic.tag==1)
                {
                    strProfilePicPath=[[response valueForKey:@"message"] valueForKey:@"image"];
                NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[response valueForKey:@"message"] valueForKey:@"image"]] ;
               [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
                    
                  //  [self removeImage:];
                    
                }
                else
                {
                    [self callGetProfileService];
                    

                }
//                UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alrt show];
                
            }
            
            
            //success
        }
    }];
    
    //imgCamera.hidden=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
    
}
- (IBAction)btnViewVendorDetail:(id)sender {
    [self callGetVendorDetail];
}

- (void)removeImage:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removedSuccessFullyAlert show];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}
#pragma mark - TextField Delegate Methods
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    
     return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField==txtName)
    {
        [txtName resignFirstResponder];
        [txtEmail becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtEmail)
    {
        [txtEmail resignFirstResponder];
        [txtPassword becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtMobileNo)
    {
        [txtMobileNo resignFirstResponder];
        [txtContactNo resignFirstResponder];
        return NO;
        
    }
    else if (textField==txtPassword)
    {
        [txtPassword resignFirstResponder];
        [txtConfirmPassword becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtConfirmPassword)
    {
        [txtConfirmPassword resignFirstResponder];
         [txtContactNo resignFirstResponder];
        return NO;
        
    }
    else if (textField==txtContactNo)
    {
        [txtContactNo resignFirstResponder];
        [tvShortBio becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtLocation)
    {
        [txtLocation resignFirstResponder];
        [txtCategory becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtCategory)
    {
        [txtCategory resignFirstResponder];
        [txtMinPrice becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtMinPrice)
    {
        [txtMinPrice resignFirstResponder];
        [txtMaxPrice becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtMaxPrice)
    {
        [txtMaxPrice resignFirstResponder];
        
        return NO;
        
    }
    else if (textField==txtFacebook)
    {
        [txtFacebook resignFirstResponder];
        [txtTwitter becomeFirstResponder];
        return NO;
        
    }
    else if (textField==txtTwitter)
    {
        [txtTwitter resignFirstResponder];
        [txtSnapChat becomeFirstResponder];
        
        
        return NO;
        
    }
    else if (textField==txtSnapChat)
    {
        [txtSnapChat resignFirstResponder];
        [txtInstagram becomeFirstResponder];
        return NO;
        
    }
    
    else{
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark - TextView Delegate Methods
#pragma mark
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor=[UIColor blackColor];
     return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
   
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Short Bio";
            textView.textColor=[UIColor grayColor];
        }
        
   
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - WebService Methods
#pragma mark
-(void)callGetProfileService
{
    [WebServiceCall getRequestWithUrl:[NSString stringWithFormat:@"%@GeneralWedHub/GetUserInfo?memberId=%@",WEBSERVICEURL,[AppUtilsShared getPreferences:@"MemberId"]] showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            dictProfileData = [[[response valueForKey:@"message"]valueForKey:@"dt_ReturnedTables"] mutableCopy];
            strVendorId=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"]objectAtIndex:0] valueForKey:@"MemberId"]];
            if(![[[[dictProfileData valueForKey:@"user"]objectAtIndex:0] valueForKey:@"UserType"] isEqualToString:@"Vendor"])
            {
                self.navigationItem.rightBarButtonItem=nil;
            }
           
            txtName.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Name"]];
            txtEmail.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Email"]];
            txtContactNo.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"PhoneNo"]];
            txtMobileNo.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"MobileNo"]];
            if(![[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Image"] isKindOfClass:[NSNull class]] && ![[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Image"] isEqualToString:@""])
            {
                NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Image"] ];
                [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
                strProfilePicPath=[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Image"];

            }
            if(![[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"ShortBio"] isEqualToString:@""])
            {
                tvShortBio.textColor=[UIColor blackColor];
                tvShortBio.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"ShortBio"]];
            }
            txtFacebook.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"FaceBook"]];
            txtTwitter.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Twitter"]];
            txtSnapChat.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"SnapChat"]];
            txtInstagram.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"Instagram"]];
            txtCategory.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"categoryname"]];
            strCategoryId=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"CategoryId"]];
            
            txtLocation.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"locationName"]];
            strLocationId=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"LocationId"]];
            
            txtMinPrice.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"MinPrice"]];
            txtMaxPrice.text=[NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"MaxPrice"]];
            lblProfileURL.text=[NSString stringWithFormat:@"  %@",[[[dictProfileData valueForKey:@"user"]objectAtIndex:0]valueForKey:@"ProfileURl"]];
        
                
                
                if( [[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"UserType"] caseInsensitiveCompare:@"Couple"] == NSOrderedSame )
            {
                
                
                lblProfileURL.hidden=YES;
                btnCopyURL.hidden=YES;
                
                
                constCategoryTop.constant=0;
                constCategoryHeight.constant=0;
                
                constMinPriceTop.constant=0;
                constMinHeight.constant=0;
                
                constMaxPriceTop.constant=0;
                constMaxHeight.constant=0;
                
                constCollectionViewHeight.constant=0;
                constCollectionViewTopWithVideo.constant=0;
                constCollectionViewTopWithPhotos.constant=0;

                constPhotosTop.constant=0;
                constPhotosHeight.constant=0;
                
                constVideosTop.constant=0;
                
                constTwitterTop.constant=0;
                 constTwitterHeight.constant=0;
                
                constFacebookTop.constant=0;
                constFacebookHeight.constant=0;

                constSnapchatTop.constant=0;
                constSnapchatHeight.constant=0;
                
                constInstagramTop.constant=0;
                 constInstagramHeight.constant=0;
                imgPhotoArrow.hidden=YES;
                imgVideoArrow.hidden=YES;

            }
           
            [_collectionView reloadData];
        }
    }];
}
-(BOOL)validation
{
    if([txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Name." withcolor:REDCOLOR];
        return NO;
    }
    if([[AppUtilsShared getPreferences:@"UserType"] isEqualToString:@"Vendor"])
    {

    if ([txtMinPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Minimum Price." withcolor:REDCOLOR];
        return NO;
    }
        
    else if ([txtMaxPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Enter Maximum Price." withcolor:REDCOLOR];
        return NO;
    }
        
    else if ([txtMinPrice.text integerValue] > [txtMaxPrice.text integerValue])
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Maximum price must not be less than minimum price" withcolor:REDCOLOR];
        return NO;
    }
    }
    return YES;
}
-(void)callDeleteImage
{
    int index;
    if(indexSelectedImage.section==0)
    {
        index=(int)indexSelectedImage.row+1;
    }
    else
    {
        index=(int)indexSelectedImage.row+4;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [AppUtilsShared getPreferences:@"MemberId"],@"MemberId",
                          [NSString stringWithFormat:@"%d",index],@"srno",
                          @"Iphone",@"device",
                          nil];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Delete_Image" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            NSLog(@"Response%@",response);
            [self callGetProfileService];
           
            
            }
    }];

}
-(void)callDeleteVedio
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AppUtilsShared getPreferences:@"MemberId"],@"MemberId",
                          [NSString stringWithFormat:@"%ld",(long)indexSelectedImage.row],@"srno",
                          @"Iphone",@"device",
                          nil];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Delete_video" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            NSLog(@"Response%@",response);
            [self callGetProfileService];
            
            
        }
    }];
    

}
-(void)callUpdateProfile
{
    if([self validation])
    {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@",txtName.text],@"name",                                                                                    [NSString stringWithFormat:@"%@",txtEmail.text],@"email",
                          [NSString stringWithFormat:@"%@",[AppUtilsShared getPreferences:@"Password"]],@"password",
                          [NSString stringWithFormat:@"%@",[[[dictProfileData valueForKey:@"user"] objectAtIndex:0] valueForKey:@"UserType"]],@"usertype",
                          [NSString stringWithFormat:@"%@",strLocationId],@"location",
                          [NSString stringWithFormat:@"%@",tvShortBio.text],@"shortbio",
                          [NSString stringWithFormat:@"%@",txtFacebook.text],@"facebook",
                          [NSString stringWithFormat:@"%@",txtTwitter.text],@"twitter",
                          [NSString stringWithFormat:@"%@",txtSnapChat.text],@"snapchat",
                          [NSString stringWithFormat:@"%@",txtInstagram.text],@"instagram",
                          [NSString stringWithFormat:@"%@",strCategoryId],@"catgegory_id",
                          [NSString stringWithFormat:@"%@",txtMinPrice.text],@"minprice",
                          [NSString stringWithFormat:@"%@",txtMaxPrice.text],@"maxprice",
                          [NSString stringWithFormat:@"%@",strProfilePicPath],@"image",
                          @"",@"phone",
                          @"",@"mobileno",
                          @"",@"new_loc",
                          @"Y",@"is_update",
                          nil];
    
    // DELEGATE.statusLoad = @"Getting Courses...";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Register" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            NSLog(@"Response%@",response);
           
            
            [self callWebserviceForQuickbloxImageUpload];
            
            
            

            
            [AppUtilsShared ShowNotificationwithMessage:[response valueForKey:@"message"] withcolor:SUCCESSCOLOR];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    }
}

-(void) callWebserviceForQuickbloxImageUpload
{
   
    NSData *imageData1 = [NSData dataWithData:UIImagePNGRepresentation(imgProfilePic.image)];
    
    
    
    [QBRequest TUploadFile: imageData1 fileName: @"MyAvatar1"
               contentType: @"image/png"
                  isPublic: YES successBlock: ^ (QBResponse * response, QBCBlob * blob) {
                       
                      
                      NSString * url = [blob publicUrl];
                      
                      
                      QBUpdateUserParameters *params = [QBUpdateUserParameters new];
                      params.blobID = [blob ID];
                      [QBRequest updateCurrentUser:params successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user)
                       {
                           NSLog(@"Response%@",response);
                           // success block
                       } errorBlock:^(QBResponse * _Nonnull response) {
                           // error block
                           NSLog(@"Failed to update user: %@", [response.error reasons]);
                       }];
                      
                      
                      
                      
                      
                  }
               statusBlock: ^ (QBRequest * request, QBRequestStatus * status) {
                   // handle progress
               }
                errorBlock: ^ (QBResponse * response) {
                    NSLog(@"error: %@", response.error);
                }
     
     
     ];
    

}
-(void)callSaveVideo
{
    if([txtInsertURL.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0)
    {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [AppUtilsShared getPreferences:@"MemberId"],@"MemberId",
                          txtInsertURL.text,@"url",
                          [AppUtilsShared getPreferences:@"CategoryId"],@"CategoryId",
                          [NSString stringWithFormat:@"%d",(int)indexSelectedImage.row],@"Sequence_no",
                          @"Iphone",@"device",
                          nil];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    
    
    [WebServiceCall postRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/Delete_video" andParameters:jsonData showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        if (Success) {
            NSLog(@"Response%@",response);
            [self callGetProfileService];
            
            
        }
    }];
    
    }
}
-(void)callGetVendorDetail
{
    [WebServiceCall getRequestWithUrl:[NSString stringWithFormat:@"%@GeneralWedHub/GetVenderDetail?VenderId=%@",WEBSERVICEURL,strVendorId] showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            WeddingItemDeailsViewController *objWeddingItemDeailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeddingItemDeailsViewController"];
            
            objWeddingItemDeailsViewController.arrVendorDetail=[[response valueForKey:@"message"] valueForKey:@"dt_ReturnedTables"];
            [self.navigationController pushViewController:objWeddingItemDeailsViewController animated:YES];
        }
    }];
    
}
#pragma mark - Action
#pragma mark
- (IBAction)btnUpdateProfile:(id)sender {
    [self.view endEditing:YES];
    [self callUpdateProfile];
}
- (IBAction)btnURLSubmit:(id)sender {
    URLView.hidden=YES;
    btnTransperencyButton.hidden=YES;
    [self callSaveVideo];
}
- (IBAction)btnCancel:(id)sender {
    URLView.hidden=YES;
    btnTransperencyButton.hidden=YES;
}
- (IBAction)btnCopyURL:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[lblProfileURL text]];
    [AppUtilsShared ShowNotificationwithMessage:@"Copied Link." withcolor:SUCCESSCOLOR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
