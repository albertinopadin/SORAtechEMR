//
//  EditMedicinesViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditMedicinesTableController.h"

@interface EditMedicinesViewController : UIViewController

@property (strong, nonatomic) EditMedicinesTableController *editMedicinesTVC;
@property (strong, nonatomic) IBOutlet UITableView *editMedicinesTableView;

- (IBAction)enableDelete:(id)sender;
- (void)generateMedicineList:(NSInteger)patientID;
- (void)saveEditedMedicinesWithPID:(NSInteger)patientID;

- (IBAction)addMedicineCell:(id)sender;

@end
