//
//  MedicationsTableViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medicine.h"
#import "MedicationCell.h"

@interface MedicationsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *medicationCellArray;

- (void)addNewMedicationCell;

@end
