//
//  WeddingItemListViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 27/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "WeddingItemListViewController.h"

@interface WeddingItemListViewController ()
{
    NSString *strVendorId;
}

@end

@implementation WeddingItemListViewController
@synthesize arrSearchData,strLocation,strCategory;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:_stTitle];
       self.navigationController.navigationBar.backgroundColor = AppColor;
   
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 320, 60)];
    
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 16)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@",strCategory];
    [vw addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 16)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"vendor in %@",strLocation];
    [vw addSubview:label];
    
    self.navigationItem.titleView = vw;
    strVendorId=@"";
 //self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:attrString];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionView Delegate methods
#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrSearchData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:100];
  if(![[[arrSearchData objectAtIndex:indexPath.row]valueForKey:@"Image"] isKindOfClass:[NSNull class]] && ![[[arrSearchData objectAtIndex:indexPath.row]valueForKey:@"Image"] isEqualToString:@""])
    {
        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[arrSearchData objectAtIndex:indexPath.row]valueForKey:@"Image"]] ;
        [img sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
    }
    else
    {
        img.image = [UIImage imageNamed:@"placeholder_image"];
    }
    img.layer.cornerRadius =img.frame.size.height/2;
       img.clipsToBounds = YES;
    

    UILabel *lblName = (UILabel *)[cell viewWithTag:101];
    lblName.text=[[arrSearchData objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    UILabel *lblCity = (UILabel *)[cell viewWithTag:102];
    lblCity.textColor= [UIColor lightGrayColor];
    lblCity.text=[[arrSearchData objectAtIndex:indexPath.row] valueForKey:@"locationName"];
    
    UILabel *lblPriceRange = (UILabel *)[cell viewWithTag:103];
    NSString *stPrice = [NSString stringWithFormat:@"$%@-$%@",[[arrSearchData objectAtIndex:indexPath.row] valueForKey:@"MinPrice"],[[arrSearchData objectAtIndex:indexPath.row] valueForKey:@"MaxPrice"]];
    lblPriceRange.text=[NSString stringWithFormat: @"Price Range: %@",stPrice ];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:lblPriceRange.text];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor lightGrayColor] range: NSMakeRange(0, 12)];
    [text addAttribute: NSForegroundColorAttributeName value: AppColor range: NSMakeRange(13, stPrice.length)];
    [lblPriceRange setAttributedText: text];
    
    EDStarRating *ratingView = (EDStarRating *)[cell viewWithTag:104];
    ratingView.backgroundColor  = [UIColor whiteColor];
    ratingView.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ratingView.maxRating = 5.0;
    ratingView.delegate = self;
    ratingView.rating=[[[arrSearchData objectAtIndex:indexPath.row] valueForKey:@"Rating"] floatValue];
    ratingView.tintColor = [UIColor colorWithRed:222.0/255.0 green:140.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    ratingView.displayMode=EDStarRatingDisplayHalf;
    
    collectionView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    strVendorId=[[arrSearchData objectAtIndex:indexPath.row]valueForKey:@"MemberId"];
    [AppUtilsShared setPreferences:strVendorId withKey:@"VenderId"];
    [self callGetVendorDetail];
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.2; //Replace the divisor with the column count requirement. Make sure to have it in float.
      CGSize size = CGSizeMake(cellWidth,200);
    return size;

}
- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
