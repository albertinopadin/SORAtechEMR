//
//  EditConditionsViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditConditionsTableController.h"

@interface EditConditionsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *conditionsList;
@property (strong, nonatomic) EditConditionsTableController *editConditionsTVC;
@property (strong, nonatomic) IBOutlet UITableView *editConditionsTableView;

- (IBAction)enableDelete:(id)sender;
- (void)generateConditionsList:(NSInteger)patientID;
- (void)saveEditedConditionsWithPID:(NSInteger)patientID;

- (IBAction)addConditionCell:(id)sender;


@end
