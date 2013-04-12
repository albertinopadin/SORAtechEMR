//
//  NPConditionsTableController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPConditionsTableController : UITableViewController

@property (strong, nonatomic) UITableView *npConditionsTableView;
@property (strong, nonatomic) NSMutableArray *textConditionsList;

- (void)addNewConditionCell;

@end
