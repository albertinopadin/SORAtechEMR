//
//  NewPatientViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface PatientPersonalInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *middleName;
@property (strong, nonatomic) IBOutlet UITextField *paternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *maternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *socialSecurity;
@property (strong, nonatomic) IBOutlet UITextField *addressLine1;
@property (strong, nonatomic) IBOutlet UITextField *addressLine2;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) Patient *patient;

//- (IBAction)okPressed:(id)sender;

@end
