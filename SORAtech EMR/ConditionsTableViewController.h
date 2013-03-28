//
//  ConditionsTableViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionCell.h"

@interface ConditionsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableSet *conditionCellSet;
@property (strong, nonatomic) NSMutableArray *conditionCellArray;
//@property (strong, nonatomic) NSMutableArray *conditionTextBoxArray;

- (void)addNewConditionCell;

@end
