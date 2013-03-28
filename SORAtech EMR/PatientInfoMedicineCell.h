//
//  PatientInfoMedicineCell.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@class PatientInfoTableViewController;

@interface PatientInfoMedicineCell : UITableViewCell

@property (strong, nonatomic) Prescriber *prescriber;
@property (strong, nonatomic) PatientInfoTableViewController *myVC;

@property (strong, nonatomic) IBOutlet UILabel *medicineNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dosageLabel;
@property (strong, nonatomic) IBOutlet UILabel *purposeLabel;
@property (strong, nonatomic) IBOutlet UILabel *frequencyLabel;

- (IBAction)prescriberTouched:(id)sender;


@end
