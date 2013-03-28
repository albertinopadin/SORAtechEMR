//
//  PatientInfoTableViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/20/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Visit.h"
#import "Medicine.h"
#import "PatientInfoConditionCell.h"
#import "PatientInfoMedicineCell.h"
#import "Prescriber.h"

@interface PatientInfoTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) Prescriber *myDoctor;
@property (strong, nonatomic) Patient *myPatient;
@property (strong, nonatomic) NSArray *visitList;
@property (strong, nonatomic) NSArray *medicineList;
@property (strong, nonatomic) NSArray *conditionList;
@property (strong, nonatomic) NSMutableSet *medicineCells;


@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *socialSecurityLabel;


@property (strong, nonatomic) IBOutlet UILabel *employerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *employerAddressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *employerAddressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *employerPhoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *employerEmailLabel;


@property (strong, nonatomic) IBOutlet UILabel *emergencyCNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emergencyCAddressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *emergencyCAddressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *emergencyCPhoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emergencyCEmailLabel;


@property (strong, nonatomic) IBOutlet UILabel *primaryInsuranceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *primaryInsurancePolicyNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *primaryInsuranceRelationshipToPrimaryLabel;


@property (strong, nonatomic) IBOutlet UILabel *secondaryInsuranceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondaryInsurancePolicyNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondaryInsuranceRelationshipToPrimaryLabel;

//@property (strong, nonatomic) IBOutlet PatientInfoConditionCell *conditionCell;

//@property (strong, nonatomic) PatientInfoMedicineCell *medicineCell;

//What to do for Conditions...?

//Medications...? 

- (void)goToPrescriberViewWithPrescriber:(Prescriber *)thePrescriber;


@end
