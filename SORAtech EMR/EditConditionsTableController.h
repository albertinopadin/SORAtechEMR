//
//  EditConditionsTableController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditConditionsTableController : UITableViewController

@property (strong, nonatomic) UITableView *editConditionsTableView;
@property (strong, nonatomic) NSMutableArray *conditionsList;

- (void)generateConditionsFromPID:(NSInteger)pID;
- (void)saveEditedConditionsWithPID:(NSInteger)patientID;
- (void)addConditionCell;

@end
