//
//  EditPatientTBViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditPatientTBViewController.h"
#import "STAppDelegate.h"
#import "PatientPersonalInfoViewController.h"
#import "NPEmployerViewController.h"
#import "NPEmergencyContactViewController.h"
#import "NPInsuranceViewController.h"
#import "PatientInfoTableViewController.h"

@interface EditPatientTBViewController ()
//@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) NSArray *vcArray;
@property (strong, nonatomic) NSArray *patientList;

@property (strong, nonatomic) PatientPersonalInfoViewController *personalVC;
@property (strong, nonatomic) NPEmployerViewController *employerVC;
@property (strong, nonatomic) NPEmergencyContactViewController *emergencyContactVC;
@property (strong, nonatomic) NPInsuranceViewController *insuranceVC;

@end

@implementation EditPatientTBViewController

@synthesize myDoctor,myPatient, vcArray, patientList, personalVC, employerVC, emergencyContactVC, insuranceVC;

//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// AlertView delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the empty fields alert view. We don't want this method firing for the empty name fields alert view
    if ([[alertView title] isEqualToString:@"Empty Fields"] && buttonIndex == 0)
    {
        [self preparePatientEdit];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Checks if there are empty text fields
- (BOOL)shouldPerformPop
{
    //Get each view controller from my array of vc's
    //self.vcArray = [self viewControllers];
//    PatientPersonalInfoViewController *personalVC = [self.vcArray objectAtIndex:0];
//    NPEmployerViewController *employerVC = [self.vcArray objectAtIndex:1];
//    NPEmergencyContactViewController *emergencyContactVC = [self.vcArray objectAtIndex:2];
//    NPInsuranceViewController *insuranceVC = [self.vcArray objectAtIndex:3];
    
    if (![personalVC namesPresent])
    {
        //Display a message if the first name, paternal or maternal last names are empty:
        UIAlertView *nameTextBoxesAreEmptyAlert = [[UIAlertView alloc] initWithTitle:@"Empty Name Fields" message:@"You must enter at least the first name and paternal and maternal last names to save a patient in the system." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [nameTextBoxesAreEmptyAlert show];
        
        return NO;
    }
    
    if ([personalVC textFieldEmpty] || [employerVC textFieldEmpty] || [emergencyContactVC textFieldEmpty] || [insuranceVC textFieldEmpty])
    {
        //Display a message if there are empty text boxes in any of the vc's:
        UIAlertView *textBoxesAreEmptyAlert = [[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"There are empty fields in the new patient form. Save patient anyway?" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [textBoxesAreEmptyAlert addButtonWithTitle:@"Proceed"];
        [textBoxesAreEmptyAlert addButtonWithTitle:@"Cancel"];
        [textBoxesAreEmptyAlert show];
        
        return NO;
    }
    else
    {
        return YES;
    }
}

// Saves the edited patient
- (void)preparePatientEdit
{
    //Get the patient information
    
    // Personal Information from first vc:
    self.myPatient.firstName = personalVC.firstName.text;
    self.myPatient.middleName = personalVC.middleName.text;
    self.myPatient.paternalLastName = personalVC.paternalLastName.text;
    self.myPatient.maternalLastName = personalVC.maternalLastName.text;
    self.myPatient.socialSecurityNumber = personalVC.socialSecurity.text;
    self.myPatient.line1 = personalVC.addressLine1.text;
    self.myPatient.line2 = personalVC.addressLine2.text;
    self.myPatient.state = personalVC.state.text;
    self.myPatient.city = personalVC.city.text;
    self.myPatient.zip = personalVC.zipCode.text;
    
    self.myPatient.dateOfBirth = personalVC.dateOfBirth.text;
    self.myPatient.phoneNumber = personalVC.phoneNumber.text;
    self.myPatient.email = personalVC.email.text;
    
    // We already have assigned this patient an id number
    //patient.patientId = [NSNumber numberWithInt:self.patientList.count + 1];
    
    
    // Employer Info from second vc:
    self.myPatient.empName = employerVC.employerName.text;
    self.myPatient.empLine1 = employerVC.employerAddressLine1.text;
    self.myPatient.empLine2 = employerVC.employerAddressLine2.text;
    //    patient.empCity =
    //    patient.empState =
    //    patient.empZip =
    self.myPatient.empPhoneNumber = employerVC.employerPhoneNum.text;
    self.myPatient.empEmail = employerVC.employerEmail.text;
    
    
    // Emergency Contact Info from third vc:
    self.myPatient.emeFirstName = emergencyContactVC.emergencyCFirstName.text;
    self.myPatient.emeMiddleName = emergencyContactVC.emergencyCMiddleName.text;
    self.myPatient.emePaternalLastName = emergencyContactVC.emergencyCPaternalLastName.text;
    self.myPatient.emeMaternalLastName = emergencyContactVC.emergencyCMaternalLastName.text;
    self.myPatient.emeLine1 = emergencyContactVC.emergencyCAddressLine1.text;
    self.myPatient.emeLine2 = emergencyContactVC.emergencyCAddressLine2.text;
    //    patient.emeCity
    //    patient.emeState
    //    patient.emeZip
    self.myPatient.emePhoneNumber = emergencyContactVC.emergencyCPhoneNumber.text;
    self.myPatient.emeEmail = emergencyContactVC.emergencyCEmail.text;
    
    
    // Insurance Info from fourth vc:
    self.myPatient.insuranceName = insuranceVC.primaryInsuranceName.text;
    self.myPatient.policyNumber = insuranceVC.primaryInsurancePolicyNum.text;
    self.myPatient.groupNumber = insuranceVC.primaryInsuranceGroupNum.text;
    
    self.myPatient.relationshipToPrimaryInsured = insuranceVC.relationshipToPrimaryInsuree.text;
    self.myPatient.piFirstName = insuranceVC.PIFirstName.text;
    self.myPatient.piMiddleName = insuranceVC.PIMiddleName.text;
    self.myPatient.piPaternalLastName = insuranceVC.PIPaternalLastName.text;
    self.myPatient.piMaternalLastName = insuranceVC.PIMaternalLastName.text;
    self.myPatient.piDateOfBirth = insuranceVC.PIDateofBirth.text;
    self.myPatient.piSocialSecurityNumber = insuranceVC.PISocialSecurityNum.text;
    self.myPatient.piLine1 = insuranceVC.PIAddressLine1.text;
    self.myPatient.piLine2 = insuranceVC.PIAddressLine2.text;
    self.myPatient.piState = insuranceVC.PIState.text;
    self.myPatient.piCity = insuranceVC.PICity.text;
    self.myPatient.piZip = insuranceVC.PIZipCode.text;
    self.myPatient.piPhoneNumber = insuranceVC.PIPhoneNum.text;
    self.myPatient.piEmail = insuranceVC.PIEmail.text;
    
    self.myPatient.sInsuranceName = insuranceVC.secondaryInsuranceName.text;
    self.myPatient.sPolicyNumber = insuranceVC.secondaryInsurancePolicyNum.text;
    self.myPatient.sGroupNumber = insuranceVC.secondaryInsuranceGroupNum.text;
    
    self.myPatient.srelationshipToPrimaryInsured = insuranceVC.relationshipToSecondaryInsuree.text;
    self.myPatient.sPiFirstName = insuranceVC.SIFirstName.text;
    self.myPatient.sPiMiddleName = insuranceVC.SIMiddleName.text;
    self.myPatient.sPiPaternalLastName = insuranceVC.SIPaternalLastName.text;
    self.myPatient.sPiMaternalLastName = insuranceVC.SIMaternalLastName.text;
    self.myPatient.sPiDateOfBirth = insuranceVC.SIDateofBirth.text;
    self.myPatient.sPiSocialSecurityNumber = insuranceVC.SISocialSecurityNum.text;
    self.myPatient.sPiLine1 = insuranceVC.SIAddressLine1.text;
    self.myPatient.sPiLine2 = insuranceVC.SIAddressLine2.text;
    self.myPatient.sPiState = insuranceVC.SIState.text;
    self.myPatient.sPiCity = insuranceVC.SICity.text;
    self.myPatient.sPiZip = insuranceVC.SIZipCode.text;
    self.myPatient.sPiPhoneNumber = insuranceVC.SIPhoneNum.text;
    self.myPatient.sPiEmail = insuranceVC.SIEmail.text;
    
    
    //Save the information using the context
    NSError *saveError = nil;
    
    [self.managedObjectContext save:&saveError];
    
    NSLog(@"Edited Patient!");
    
    // Return the logged-in doctor
    //HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    //hvc.myDoctor = self.myDoctor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Get each view controller from my array of vc's
    self.vcArray = [self viewControllers];
    
    self.selectedViewController = [[self viewControllers] objectAtIndex:1];
    self.selectedViewController = [[self viewControllers] objectAtIndex:2];
    self.selectedViewController = [[self viewControllers] objectAtIndex:3];
    self.selectedViewController = [[self viewControllers] objectAtIndex:0];
    
    self.personalVC = [self.vcArray objectAtIndex:0];
    self.employerVC = [self.vcArray objectAtIndex:1];
    self.emergencyContactVC = [self.vcArray objectAtIndex:2];
    self.insuranceVC = [self.vcArray objectAtIndex:3];
    
    
    // Put already saved info:
    
    // Personal Information in first vc:
    personalVC.firstName.text = self.myPatient.firstName;
    personalVC.middleName.text = self.myPatient.middleName;
    personalVC.paternalLastName.text = self.myPatient.paternalLastName;
    personalVC.maternalLastName.text = self.myPatient.maternalLastName;
    personalVC.socialSecurity.text = self.myPatient.socialSecurityNumber;
    personalVC.addressLine1.text = self.myPatient.line1;
    personalVC.addressLine2.text = self.myPatient.line2;
    personalVC.state.text = self.myPatient.state;
    personalVC.city.text = self.myPatient.city;
    personalVC.zipCode.text = self.myPatient.zip;
    
    personalVC.dateOfBirth.text = self.myPatient.dateOfBirth;
    personalVC.phoneNumber.text = self.myPatient.phoneNumber;
    personalVC.email.text = self.myPatient.email;
    
    // We already have assigned this patient an id number
    //patient.patientId = [NSNumber numberWithInt:self.patientList.count + 1];
    
    
    // Employer Info in second vc:
    employerVC.employerName.text = self.myPatient.empName;
    employerVC.employerAddressLine1.text = self.myPatient.empLine1;
    employerVC.employerAddressLine2.text = self.myPatient.empLine2;
    //    patient.empCity =
    //    patient.empState =
    //    patient.empZip =
    employerVC.employerPhoneNum.text = self.myPatient.empPhoneNumber;
    employerVC.employerEmail.text = self.myPatient.empEmail;
    
    
    // Emergency Contact Info in third vc:
    emergencyContactVC.emergencyCFirstName.text = self.myPatient.emeFirstName;
    emergencyContactVC.emergencyCMiddleName.text = self.myPatient.emeMiddleName;
    emergencyContactVC.emergencyCPaternalLastName.text = self.myPatient.emePaternalLastName;
    emergencyContactVC.emergencyCMaternalLastName.text = self.myPatient.emeMaternalLastName;
    emergencyContactVC.emergencyCAddressLine1.text = self.myPatient.emeLine1;
    emergencyContactVC.emergencyCAddressLine2.text = self.myPatient.emeLine2;
    //    patient.emeCity
    //    patient.emeState
    //    patient.emeZip
    emergencyContactVC.emergencyCPhoneNumber.text = self.myPatient.emePhoneNumber;
    emergencyContactVC.emergencyCEmail.text = self.myPatient.emeEmail;
    
    
    // Insurance Info in fourth vc:
    insuranceVC.primaryInsuranceName.text = self.myPatient.insuranceName;
    insuranceVC.primaryInsurancePolicyNum.text = self.myPatient.policyNumber;
    insuranceVC.primaryInsuranceGroupNum.text = self.myPatient.groupNumber;
    
    insuranceVC.relationshipToPrimaryInsuree.text = self.myPatient.relationshipToPrimaryInsured;
    insuranceVC.PIFirstName.text = self.myPatient.piFirstName;
    insuranceVC.PIMiddleName.text = self.myPatient.piMiddleName;
    insuranceVC.PIPaternalLastName.text = self.myPatient.piPaternalLastName;
    insuranceVC.PIMaternalLastName.text = self.myPatient.piMaternalLastName;
    insuranceVC.PIDateofBirth.text = self.myPatient.piDateOfBirth;
    insuranceVC.PISocialSecurityNum.text = self.myPatient.piSocialSecurityNumber;
    insuranceVC.PIAddressLine1.text = self.myPatient.piLine1;
    insuranceVC.PIAddressLine2.text = self.myPatient.piLine2;
    insuranceVC.PIState.text = self.myPatient.piState;
    insuranceVC.PICity.text = self.myPatient.piCity;
    insuranceVC.PIZipCode.text = self.myPatient.piZip;
    insuranceVC.PIPhoneNum.text = self.myPatient.piPhoneNumber;
    insuranceVC.PIEmail.text = self.myPatient.piEmail;
    
    insuranceVC.secondaryInsuranceName.text = self.myPatient.sInsuranceName;
    insuranceVC.secondaryInsurancePolicyNum.text = self.myPatient.sPolicyNumber;
    insuranceVC.secondaryInsuranceGroupNum.text = self.myPatient.sGroupNumber;
    
    insuranceVC.relationshipToSecondaryInsuree.text =self.myPatient.srelationshipToPrimaryInsured;
    insuranceVC.SIFirstName.text = self.myPatient.sPiFirstName;
    insuranceVC.SIMiddleName.text = self.myPatient.sPiMiddleName;
    insuranceVC.SIPaternalLastName.text = self.myPatient.sPiPaternalLastName;
    insuranceVC.SIMaternalLastName.text = self.myPatient.sPiMaternalLastName;
    insuranceVC.SIDateofBirth.text = self.myPatient.sPiDateOfBirth;
    insuranceVC.SISocialSecurityNum.text = self.myPatient.sPiSocialSecurityNumber;
    insuranceVC.SIAddressLine1.text = self.myPatient.sPiLine1;
    insuranceVC.SIAddressLine2.text = self.myPatient.sPiLine2;
    insuranceVC.SIState.text = self.myPatient.sPiState;
    insuranceVC.SICity.text = self.myPatient.sPiCity;
    insuranceVC.SIZipCode.text = self.myPatient.sPiZip;
    insuranceVC.SIPhoneNum.text = self.myPatient.sPiPhoneNumber;
    insuranceVC.SIEmail.text = self.myPatient.sPiEmail;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Pop the edit vc and go back to patient info view
- (IBAction)doneEditingPatient:(id)sender
{
    if ([self shouldPerformPop])
    {
        [self preparePatientEdit];
        // Return the logged-in doctor
        NSArray *vcs = [self.navigationController viewControllers];
        NSInteger numVCs = vcs.count;
        PatientInfoTableViewController *pitvc = [vcs objectAtIndex:numVCs - 1];
        pitvc.myDoctor = self.myDoctor;
        pitvc.myPatient = self.myPatient;
        
        // Pop to previous vc:
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
