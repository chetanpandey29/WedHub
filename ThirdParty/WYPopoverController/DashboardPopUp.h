//
//  DashboardPopUp.h
//  Profiler
//
//  Created by Flexi_Mac4 on 02/08/15.
//  Copyright (c) 2015 Aarin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KPPopUp <NSObject>

@optional
-(void)SelectedValue :(NSString *)strValue;

@end

@interface DashboardPopUp : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) id<KPPopUp> delegate;

@property (nonatomic,strong) NSArray *arrData;

@property (nonatomic,strong) NSString *selectedString;
@property (nonatomic,assign) BOOL IsMultiSelect;
@property (nonatomic,assign) BOOL IsSingleSelect;


@end
