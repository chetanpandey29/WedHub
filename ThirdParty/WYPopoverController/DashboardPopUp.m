//
//  DashboardPopUp.m
//  Profiler
//
//  Created by Flexi_Mac4 on 02/08/15.
//  Copyright (c) 2015 Aarin. All rights reserved.
//

#import "DashboardPopUp.h"

@interface DashboardPopUp ()
{
    NSMutableArray *arrSelectedData;
}

@end

@implementation DashboardPopUp

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    if (_IsMultiSelect) {
        
        
        arrSelectedData = [[NSMutableArray alloc] init];
        if (_selectedString.length > 0)
        {
            arrSelectedData = [[_selectedString componentsSeparatedByString:@","] mutableCopy];
        }
        
    }
    if (_IsSingleSelect)
    {
        arrSelectedData = [[NSMutableArray alloc] init];
        if (_selectedString.length > 0)
        {
            [arrSelectedData addObject:_selectedString];
        }
        
    }
    
    // Do any additional setup after loading the view.
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_IsMultiSelect)
    {
        if ([arrSelectedData containsObject:[_arrData objectAtIndex:indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (_IsSingleSelect)
    {
        if ([arrSelectedData containsObject:[_arrData objectAtIndex:indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

        cell.textLabel.font = [UIFont systemFontOfSize:15];
  
    
    cell.textLabel.numberOfLines=2;
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.8;
    
    
  
    cell.textLabel.text = [_arrData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_IsMultiSelect)
    {
        
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [arrSelectedData removeObject:[_arrData objectAtIndex:indexPath.row]];
        }
        else
        {
            [arrSelectedData addObject:[_arrData objectAtIndex:indexPath.row]];
        }
        
       
        [_delegate SelectedValue:[arrSelectedData componentsJoinedByString:@","]];
    }
    else if (_IsSingleSelect)
    {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [arrSelectedData removeObject:[_arrData objectAtIndex:indexPath.row]];
        }
        else
        {
            [arrSelectedData addObject:[_arrData objectAtIndex:indexPath.row]];
            
        }
        [_delegate SelectedValue:[_arrData objectAtIndex:indexPath.row]];
    }
    else
    {
        
        
        [_delegate SelectedValue:[_arrData objectAtIndex:indexPath.row]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
