//
//  NPMedicinesViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPMedicinesTableController.h"

@interface NPMedicinesViewController : UIViewController

@property (strong, nonatomic) NSNumber *myPatientId;
@property (strong, nonatomic) NPMedicinesTableController *npMedicinesTVC;
@property (strong, nonatomic) IBOutlet UITableView *npMedicationsTableView;

- (IBAction)addNewMedication:(id)sender;
- (void)saveMedications:(NSInteger)patientID;

@end
