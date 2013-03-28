//
//  PatientTableViewCell.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientTableViewCell.h"

@implementation PatientTableViewCell

@synthesize parentVC, index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)viewRecordButtonPressed:(id)sender
{
    self.parentVC.patientIndex = self.index;
    [self.parentVC performSegueFromCellWithIndex:self.index andName:@"toPatientVisitListSegue"];
}

- (IBAction)viewInfoButtonPressed:(id)sender
{
    self.parentVC.patientIndex = self.index;
    [self.parentVC performSegueFromCellWithIndex:self.index andName:@"viewPatientInfoSegue"];
}

@end
