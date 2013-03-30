//
//  NPInsuranceViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPInsuranceViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

// Primary Insurance
@property (strong, nonatomic) IBOutlet UITextField *primaryInsuranceName;
@property (strong, nonatomic) IBOutlet UITextField *primaryInsurancePolicyNum;
@property (strong, nonatomic) IBOutlet UITextField *primaryInsuranceGroupNum;
@property (strong, nonatomic) IBOutlet UITextField *relationshipToPrimaryInsuree;

// Primary Insuree Info
@property (strong, nonatomic) IBOutlet UITextField *PIFirstName;
@property (strong, nonatomic) IBOutlet UITextField *PIMiddleName;
@property (strong, nonatomic) IBOutlet UITextField *PIPaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *PIMaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *PIDateofBirth;
@property (strong, nonatomic) IBOutlet UITextField *PISocialSecurityNum;
@property (strong, nonatomic) IBOutlet UITextField *PIAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *PIAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *PIState;
@property (strong, nonatomic) IBOutlet UITextField *PICity;
@property (strong, nonatomic) IBOutlet UITextField *PIZipCode;
@property (strong, nonatomic) IBOutlet UITextField *PIPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *PIEmail;

// Secondary Insurance
@property (strong, nonatomic) IBOutlet UITextField *secondaryInsuranceName;
@property (strong, nonatomic) IBOutlet UITextField *secondaryInsurancePolicyNum;
@property (strong, nonatomic) IBOutlet UITextField *secondaryInsuranceGroupNum;
@property (strong, nonatomic) IBOutlet UITextField *relationshipToSecondaryInsuree;

// Secondary Insuree Info
@property (strong, nonatomic) IBOutlet UITextField *SIFirstName;
@property (strong, nonatomic) IBOutlet UITextField *SIMiddleName;
@property (strong, nonatomic) IBOutlet UITextField *SIPaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *SIMaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *SIDateofBirth;
@property (strong, nonatomic) IBOutlet UITextField *SISocialSecurityNum;
@property (strong, nonatomic) IBOutlet UITextField *SIAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *SIAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *SIState;
@property (strong, nonatomic) IBOutlet UITextField *SICity;
@property (strong, nonatomic) IBOutlet UITextField *SIZipCode;
@property (strong, nonatomic) IBOutlet UITextField *SIPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *SIEmail;

// To check if any of the text fields are empty
@property (strong, nonatomic) NSArray *textFields;

- (BOOL)textFieldEmpty;

@end
