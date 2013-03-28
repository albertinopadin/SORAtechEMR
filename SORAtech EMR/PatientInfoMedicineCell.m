//
//  PatientInfoMedicineCell.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientInfoMedicineCell.h"
#import "PatientInfoTableViewController.h"

@implementation PatientInfoMedicineCell

@synthesize medicineNameLabel, dosageLabel, frequencyLabel, purposeLabel, prescriber, myVC;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PatientInfoMedicineCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)prescriberTouched:(id)sender
{
    [self.myVC goToPrescriberViewWithPrescriber:self.prescriber];
}

@end
