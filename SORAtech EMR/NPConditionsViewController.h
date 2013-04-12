//
//  NPConditionsViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPConditionsTableController.h"

@interface NPConditionsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *textConditionsList;
@property (strong, nonatomic) NPConditionsTableController *npConditionsTVC;
@property (strong, nonatomic) IBOutlet UITableView *npConditionsTableView;

- (IBAction)addCondition:(id)sender;

@end
