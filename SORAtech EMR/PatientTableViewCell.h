//
//  PatientTableViewCell.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientSearchResultTVC.h"

@interface PatientTableViewCell : UITableViewCell

@property (strong, nonatomic) PatientSearchResultTVC *parentVC;
@property (atomic) NSInteger index;

@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *socialSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *patientIDLabel;

- (IBAction)viewRecordButtonPressed:(id)sender;
- (IBAction)viewInfoButtonPressed:(id)sender;


@end
