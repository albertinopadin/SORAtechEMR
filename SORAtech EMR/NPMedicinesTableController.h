//
//  NPMedicinesTableController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPMedicinesTableController : UITableViewController

@property (strong, nonatomic) UITableView *npMedicinesTableView;
@property (strong, nonatomic) NSMutableArray *medicinesList;

- (void)addNewMedicineCell;
- (void)saveMedications:(NSInteger)patientID;

@end
