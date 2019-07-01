//
//  DashboardViewController.m
//  WedHub
//
//  Created by Flexi_Mac2 on 21/12/16.
//  Copyright © 2016 Flexi_Mac2. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()
{
    UICollectionView *collectionView1;
    NSMutableArray *arrCategory,*arrSearchCategory,*arrLocation,*arrLoc;
    UIButton *btnTransperencyButton;
    NSIndexPath *selectedIndex;
    NSString *strSelectedLocation,*strLocationId,*strCategoryId,* strCategory;
}
@end

@implementation DashboardViewController
@synthesize stTitle,btnFilter,CollectionView,SearchBar,vwAddress1,vwAddress2,vwAddress3,vwAddress4,vwAll,vwMore,btnAll,btnAddress1,btnAddress2,btnAddress3,btnAddress4,btnMore,tblSearchCategory,consttblSearchCatHeight,vwMoreLocation,btnLocationApply,SearchBarLocation,tblLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (Delegate.isFromAppdelegate) {
        Delegate.isFromAppdelegate=NO;
        
        Delegate.loadingView = [[UIView alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-100)/2,([[UIScreen mainScreen] bounds].size.height-100)/2,100,100)];
        
        Delegate.loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
        Delegate.loadingView.layer.cornerRadius = 5;
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        // activityView.center = CGPointMake(200,300);
        activityView.center = CGPointMake(Delegate.loadingView.frame.size.width / 2.0, 35);
        [activityView startAnimating];
        activityView.tag = 100;
        [Delegate.loadingView addSubview:activityView];
        
        UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 100, 80)];
        lblLoading.text = @"connecting to chat server...";
        lblLoading.textColor = [UIColor whiteColor];
        lblLoading.numberOfLines=2;
        lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
        lblLoading.textAlignment = NSTextAlignmentCenter;
        [Delegate.loadingView addSubview:lblLoading];
        [Delegate.loadingView setHidden:NO];
        [self.view addSubview:Delegate.loadingView];

    }
    
    
    
    self.navigationController.navigationBar.hidden=NO;
    
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView=[AppUtilsShared getNavigationTitle:@"WED HUB"];
    [self setButtonColor];
    arrCategory=[[NSMutableArray alloc]init];
    arrSearchCategory=[[NSMutableArray alloc]init];
    arrLocation=[[NSMutableArray alloc]init];
    arrLoc=[[NSMutableArray alloc]init];
    
    
    vwMore.layer.cornerRadius=vwMore.frame.size.height/2;
    
    vwAll.layer.cornerRadius=vwAll.frame.size.height/2;
    vwAll.backgroundColor=AppColor;
    vwAll.alpha=1.0;
    
    vwAddress1.layer.cornerRadius=vwAddress1.frame.size.height/2;
    
    vwAddress2.layer.cornerRadius=vwAddress2.frame.size.height/2;
    
    vwAddress3.layer.cornerRadius=vwAddress3.frame.size.height/2;
    
    vwAddress4.layer.cornerRadius=vwAddress4.frame.size.height/2;
    tblSearchCategory.hidden=YES;
    tblSearchCategory.layer.borderColor=[UIColor lightGrayColor].CGColor;
    tblSearchCategory.layer.borderWidth=1.0;
    tblSearchCategory.layer.cornerRadius=5;
    
    SearchBar.layer.cornerRadius = SearchBar.frame.size.height/2; // I've tried other numbers besides this too with no luck
    SearchBar.clipsToBounds = true;
    SearchBar.barTintColor=[UIColor whiteColor];
    
    SearchBar.delegate=self;
    SearchBar.placeholder=@"Category";
    
    
    SearchBarLocation.barTintColor=[UIColor whiteColor];
    SearchBarLocation.placeholder=@"Search Location";
    vwMoreLocation.hidden=YES;
    strLocationId=@"";
    strCategoryId=@"";
    btnLocationApply.backgroundColor=AppColor;
    [btnLocationApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AppUtilsShared setButtonRadius:btnLocationApply];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITextField *textField = [SearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    [self callGetLocation];
    [self callGetCategory];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btnSideMenu:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
    
}
#pragma mark - Action
- (IBAction)btnFilter:(id)sender {
    FilterViewController *objFilterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    
    [self.navigationController pushViewController:objFilterViewController animated:YES];
    
}

- (IBAction)btnAll:(id)sender {
    [self setButtonColor];
    vwAll.backgroundColor=AppColor;
    vwAll.alpha=1.0;
    strLocationId=@"";
}
- (IBAction)btnAddress1:(id)sender {
    [self setButtonColor];
    vwAddress1.backgroundColor=AppColor;
    vwAddress1.alpha=1.0;
    NSString *SearchTerm=@"1";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm];
    strLocationId=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"LocationId"]];
    strSelectedLocation=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"locationName"]];
    
    
}
- (IBAction)btnAddress2:(id)sender {
    [self setButtonColor];
    vwAddress2.backgroundColor=AppColor;
    vwAddress2.alpha=1.0;
    NSString *SearchTerm=@"2";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm];
    strLocationId=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"LocationId"]];
    strSelectedLocation=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"locationName"]];
}
- (IBAction)btnAddress3:(id)sender {
    [self setButtonColor];
    vwAddress3.backgroundColor=AppColor;
    vwAddress3.alpha=1.0;
    NSString *SearchTerm=@"3";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm];
    strLocationId=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"LocationId"]];
    strSelectedLocation=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"locationName"]];
}
- (IBAction)btnAddress4:(id)sender {
    [self setButtonColor];
    vwAddress4.backgroundColor=AppColor;
    vwAddress4.alpha=1.0;
    NSString *SearchTerm=@"4";
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm];
    strLocationId=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"LocationId"]];
    strSelectedLocation=[NSString stringWithFormat:@"%@",[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"locationName"]];
    
}
- (IBAction)btnMore:(id)sender {
    [self setButtonColor];
    [self.view endEditing:YES];
    vwMore.backgroundColor=AppColor;
    vwMore.alpha=1.0;
    
    btnTransperencyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    btnTransperencyButton.backgroundColor = [UIColor blackColor];
    btnTransperencyButton.alpha=0.6;
    [btnTransperencyButton addTarget:self action:@selector(dismissHelper:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btnTransperencyButton belowSubview:vwMoreLocation];
    vwMoreLocation.hidden=NO;
    [tblLocation reloadData];
    
}
-(void)dismissHelper:(id)sender
{
    vwMoreLocation.hidden=YES;
    btnTransperencyButton.hidden=YES;
    
}
- (IBAction)btnSearch:(id)sender {
    [self.view endEditing:YES];
    strCategory=SearchBar.text;
    [self callSearchWebService];
    
}
- (IBAction)btnLocationApply:(id)sender {
    vwMoreLocation.hidden=YES;
    btnTransperencyButton.hidden=YES;
    if([strSelectedLocation length]>0)
    {
        [btnAddress1 setTitle:strSelectedLocation forState:UIControlStateNormal];
        [self setButtonColor];
        vwAddress1.backgroundColor=AppColor;
        vwAddress1.alpha=1.0;
    }
    
}

-(void)setButtonColor
{
    vwAddress2.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    vwAddress1.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    vwAddress3.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    vwAddress4.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    vwAll.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    vwMore.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:0.5];
    
}
#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrCategory.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CollectionCell";
    
    UICollectionViewCell *collectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIView *vwBackground = (UIView *)[collectioncell.contentView viewWithTag:1];
    vwBackground.layer.cornerRadius=vwBackground.frame.size.height/2;
    vwBackground.layer.borderWidth=0.5;
    vwBackground.layer.borderColor=AppColor.CGColor;
    // vwBackground.backgroundColor=AppColor;
    
    UIImageView *ivMenu = (UIImageView *)[collectioncell.contentView viewWithTag:2];
    ivMenu.layer.cornerRadius = ivMenu.frame.size.width / 2;
    ivMenu.clipsToBounds = YES;
    ivMenu.layer.borderColor=AppColor.CGColor;
    ivMenu.layer.borderWidth=1.0f;
    
    UILabel *lbl = (UILabel *)[collectioncell viewWithTag:3];
    if (arrCategory.count>0)
        
    {
        NSString *temp = [NSString stringWithFormat:@"%@%@",WEBSERVICEURL1,[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Icon"]] ;
        [ivMenu sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_photo"]]];
        
        //ivMenu.image = [UIImage imageNamed:@"wedding"];
        
        lbl.text=[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Name"];
        lbl.textAlignment = NSTextAlignmentCenter;
        
    }
    
    
    
    
    return collectioncell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // SearchBar.text=[NSString stringWithFormat:@"%@",[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Name"]];
    strCategoryId=[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"CategoryId"];
    strCategory=[NSString stringWithFormat:@"%@",[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Name"]];
    
    [self callSearchWebService];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    
    CGSize size = CGSizeMake(cellWidth,80);
    return size;
}
#pragma mark - Table View View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==tblSearchCategory)
    {
        return [arrCategory count];
    }
    else
    {
        return [arrLocation count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(tableView == tblSearchCategory)
    {
        // Display recipe in the table cell
        cell.textLabel.text=[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Name"];
    }
    else
    {
        NSLog(@"%d",(int)cell.imageView.tag);
        if([indexPath isEqual:selectedIndex])
        {
            cell.imageView.tag=1;
        }
        else
        {
            cell.imageView.tag=0;
        }
        if(cell.imageView.tag==0)
        {
            cell.textLabel.text=[[arrLocation objectAtIndex:indexPath.row]valueForKey:@"locationName"];
            cell.imageView.frame = CGRectMake(0,0,20,20);
            [cell.imageView setImage:[UIImage imageNamed:@"Round Unfill"]];
            
        }
        else
        {
            cell.textLabel.text=[[arrLocation objectAtIndex:indexPath.row]valueForKey:@"locationName"];
            cell.imageView.frame = CGRectMake(0,0,20,20);
            strSelectedLocation=[[arrLocation objectAtIndex:indexPath.row]valueForKey:@"locationName"];
            strLocationId=[[arrLocation objectAtIndex:indexPath.row]valueForKey:@"LocationId"];
            [cell.imageView setImage:[UIImage imageNamed:@"Round Fill"]];
            
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==tblSearchCategory)
    {
        SearchBar.text=[NSString stringWithFormat:@"%@",[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"Name"]];
        [SearchBar resignFirstResponder];
        tblSearchCategory.hidden=YES;
        strCategoryId=[[arrCategory objectAtIndex:indexPath.row] valueForKey:@"CategoryId"];
    }
    else
    {
        UITableViewCell *cell=(UITableViewCell *)[tblLocation cellForRowAtIndexPath:indexPath];
        
        if(cell.imageView.tag==0)
        {
            [cell.imageView setImage:[UIImage imageNamed:@"Round Fill"]];
            cell.imageView.tag=1;
            selectedIndex=indexPath;
        }
        else
        {
            [cell.imageView setImage:[UIImage imageNamed:@"Round Unfill"]];
            cell.imageView.tag=0;
            selectedIndex=[[NSIndexPath alloc] init];
            
        }
        [tblLocation reloadData];
        
    }
    
}

#pragma mark - Web Service
-(void)callGetCategory
{
    [WebServiceCall getRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/GetCategories" showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            arrCategory = [[response valueForKey:@"message"] mutableCopy];
            arrSearchCategory=[arrCategory mutableCopy];
            [CollectionView reloadData];
            
        }
    }];
    
}
-(void)callGetLocation
{
    [WebServiceCall getRequestWithUrl:WEBSERVICEURL@"GeneralWedHub/GetLocation" showLoader:YES response:^(id response, NSError *error, BOOL Success) {
        
        if(Success)
        {
            NSLog(@"Location : %@",response);
            arrLocation = [[NSMutableArray alloc]init];
            arrLoc=[[NSMutableArray alloc]init];
            arrLocation = [[response valueForKey:@"message"] mutableCopy];
            for (int i=0; i<arrLocation.count; i++) {
                if (![[[arrLocation objectAtIndex:i]valueForKey:@"locationName"] isKindOfClass:[NSNull class]] && ![[[arrLocation objectAtIndex:i]valueForKey:@"LocationId"] isKindOfClass:[NSNull class]]) {
                    
                    [arrLoc addObject:[arrLocation objectAtIndex:i]];
                    
                }
            }
            arrLocation = [arrLoc mutableCopy];
            NSString *SearchTerm=@"1";
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm];
            
            [btnAddress1 setTitle:[[[arrLocation filteredArrayUsingPredicate:resultPredicate] objectAtIndex:0]valueForKey:@"locationName"] forState:UIControlStateNormal];
            
            NSString *SearchTerm1=@"2";
            NSPredicate *resultPredicate1 = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm1];
            [btnAddress2 setTitle:[[[arrLocation filteredArrayUsingPredicate:resultPredicate1] objectAtIndex:0]valueForKey:@"locationName"] forState:UIControlStateNormal];
            NSString *SearchTerm2=@"3";
            NSPredicate *resultPredicate2 = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm2];
            
            [btnAddress3 setTitle:[[[arrLocation filteredArrayUsingPredicate:resultPredicate2] objectAtIndex:0]valueForKey:@"locationName"] forState:UIControlStateNormal];
            
            NSString *SearchTerm3=@"4";
            NSPredicate *resultPredicate3 = [NSPredicate predicateWithFormat:@"RankId == %@",SearchTerm3];
            [btnAddress4 setTitle:[[[arrLocation filteredArrayUsingPredicate:resultPredicate3] objectAtIndex:0]valueForKey:@"locationName"] forState:UIControlStateNormal];
            
        }
    }];
    
}
-(void)callSearchWebService
{
    if([strCategoryId length]>0)
    {
        [WebServiceCall getRequestWithUrl:[NSString stringWithFormat:@"%@GeneralWedHub/GetSearchData?LocationId=%@&CategoryId=%@",WEBSERVICEURL,[NSString stringWithFormat:@"%@",strLocationId],[NSString stringWithFormat:@"%@",strCategoryId]] showLoader:YES response:^(id response, NSError *error, BOOL Success) {
            
            if(Success)
            {
                NSLog(@"Response : %@",response);
                WeddingItemListViewController *objWeddingItemListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeddingItemListViewController"];
                objWeddingItemListViewController.arrSearchData=[[NSMutableArray alloc]initWithArray:[response valueForKey:@"message"]];
               objWeddingItemListViewController.strCategory=[strCategory uppercaseString];
                if([strSelectedLocation isEqualToString:@""] || strSelectedLocation == nil)
                {
                    objWeddingItemListViewController.strLocation=@"ALL";
                }
                else
                {
                    objWeddingItemListViewController.strLocation=[strSelectedLocation uppercaseString];
                }
                [self.navigationController pushViewController:objWeddingItemListViewController animated:YES];
            }
        }];
    }
    else
    {
        [AppUtilsShared ShowNotificationwithMessage:@"Please Select Category." withcolor:REDCOLOR];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchBar.text=[NSString stringWithFormat:@"%@",searchText];
    if(searchBar==SearchBar)
    {
        
        arrCategory=[arrSearchCategory mutableCopy];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[c] %@", searchText];
        if([searchText length] > 0)
        {
            arrCategory = [[NSMutableArray alloc]initWithArray:[arrCategory filteredArrayUsingPredicate:resultPredicate]];
        }
        else
        {
            arrCategory=[arrSearchCategory mutableCopy];
        }
        tblSearchCategory.hidden=NO;
        if(arrCategory.count<=3)
        {
            consttblSearchCatHeight.constant=arrCategory.count*44;
        }
        else
        {
            consttblSearchCatHeight.constant=142;
        }
        [tblSearchCategory reloadData];
    }
    else
    {
        
        arrLocation=[arrLoc mutableCopy];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"locationName BEGINSWITH[c] %@", searchText];
        if([searchText length] > 0)
        {
            arrLocation = [[NSMutableArray alloc]initWithArray:[arrLocation filteredArrayUsingPredicate:resultPredicate]];
        }
        else
        {
            arrLocation=[arrLoc mutableCopy];
        }
        tblLocation.hidden=NO;
        [tblLocation reloadData];
        
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
@end
