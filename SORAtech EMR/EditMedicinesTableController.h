//
//  EditMedicinesTableController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMedicinesTableController : UITableViewController

@property (strong, nonatomic) UITableView *editMedicinesTableView;
@property (strong, nonatomic) NSMutableArray *medicineList;

- (void)generateMedicinesFromPID:(NSInteger)pID;
- (void)saveEditedMedicinesWithPID:(NSInteger)patientID;
- (void)addMedicineCell;

@end
