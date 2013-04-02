//
//  NewPatientTBViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/28/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NewPatientTBViewController.h"
#import "STAppDelegate.h"
#import "PatientPersonalInfoViewController.h"
#import "NPEmployerViewController.h"
#import "NPEmergencyContactViewController.h"
#import "NPInsuranceViewController.h"
#import "HomeViewController.h"

@interface NewPatientTBViewController ()

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) NSArray *vcArray;
@property (strong, nonatomic) NSArray *patientList;

@end

@implementation NewPatientTBViewController

@synthesize patient, vcArray, patientList, myDoctor;

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
        [self performSegueWithIdentifier:@"addPatientDoneSegue" sender:self];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //Get each view controller from my array of vc's
    self.vcArray = [self viewControllers];
    PatientPersonalInfoViewController *personalVC = [self.vcArray objectAtIndex:0];
    NPEmployerViewController *employerVC = [self.vcArray objectAtIndex:1];
    NPEmergencyContactViewController *emergencyContactVC = [self.vcArray objectAtIndex:2];
    NPInsuranceViewController *insuranceVC = [self.vcArray objectAtIndex:3];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Get each view controller from my array of vc's
    self.vcArray = [self viewControllers];
    PatientPersonalInfoViewController *personalVC = [self.vcArray objectAtIndex:0];
    NPEmployerViewController *employerVC = [self.vcArray objectAtIndex:1];
    NPEmergencyContactViewController *emergencyContactVC = [self.vcArray objectAtIndex:2];
    NPInsuranceViewController *insuranceVC = [self.vcArray objectAtIndex:3];

    // Get patient list
    //Create fetch request for the Patient entity table
    NSFetchRequest *patientListFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
    
    //Execute the fetch request through the managed object context to get the patient list
    self.patientList = [self.managedObjectContext executeFetchRequest:patientListFetchRequest error:nil];
    
    //Insert a new patient in the patient table
    patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    
    //Get the patient information
    
    // Personal Information from first vc:
    patient.firstName = personalVC.firstName.text;
    patient.middleName = personalVC.middleName.text;
    patient.paternalLastName = personalVC.paternalLastName.text;
    patient.maternalLastName = personalVC.maternalLastName.text;
    patient.socialSecurityNumber = personalVC.socialSecurity.text;
    patient.line1 = personalVC.addressLine1.text;
    patient.line2 = personalVC.addressLine2.text;
    patient.state = personalVC.state.text;
    patient.city = personalVC.city.text;
    patient.zip = personalVC.zipCode.text;
    
    patient.dateOfBirth = personalVC.dateOfBirth.text;
    patient.phoneNumber = personalVC.phoneNumber.text;
    patient.email = personalVC.email.text;
    
    patient.patientId = [NSNumber numberWithInt:self.patientList.count + 1];
    
    
    // Employer Info from second vc:
    patient.empName = employerVC.employerName.text;
    patient.empLine1 = employerVC.employerAddressLine1.text;
    patient.empLine2 = employerVC.employerAddressLine2.text;
//    patient.empCity =
//    patient.empState =
//    patient.empZip =
    patient.empPhoneNumber = employerVC.employerPhoneNum.text;
    patient.empEmail = employerVC.employerEmail.text;
    
    
    // Emergency Contact Info from third vc:
    patient.emeFirstName = emergencyContactVC.emergencyCFirstName.text;
    patient.emeMiddleName = emergencyContactVC.emergencyCMiddleName.text;
    patient.emePaternalLastName = emergencyContactVC.emergencyCPaternalLastName.text;
    patient.emeMaternalLastName = emergencyContactVC.emergencyCMaternalLastName.text;
    patient.emeLine1 = emergencyContactVC.emergencyCAddressLine1.text;
    patient.emeLine2 = emergencyContactVC.emergencyCAddressLine2.text;
//    patient.emeCity
//    patient.emeState
//    patient.emeZip
    patient.emePhoneNumber = emergencyContactVC.emergencyCPhoneNumber.text;
    patient.emeEmail = emergencyContactVC.emergencyCEmail.text;
    
    
    // Insurance Info from fourth vc:
    patient.insuranceName = insuranceVC.primaryInsuranceName.text;
    patient.policyNumber = insuranceVC.primaryInsurancePolicyNum.text;
    patient.groupNumber = insuranceVC.primaryInsuranceGroupNum.text;
    
    patient.relationshipToPrimaryInsured = insuranceVC.relationshipToPrimaryInsuree.text;
    patient.piFirstName = insuranceVC.PIFirstName.text;
    patient.piMiddleName = insuranceVC.PIMiddleName.text;
    patient.piPaternalLastName = insuranceVC.PIPaternalLastName.text;
    patient.piMaternalLastName = insuranceVC.PIMaternalLastName.text;
    patient.piDateOfBirth = insuranceVC.PIDateofBirth.text;
    patient.piSocialSecurityNumber = insuranceVC.PISocialSecurityNum.text;
    patient.piLine1 = insuranceVC.PIAddressLine1.text;
    patient.piLine2 = insuranceVC.PIAddressLine2.text;
    patient.piState = insuranceVC.PIState.text;
    patient.piCity = insuranceVC.PICity.text;
    patient.piZip = insuranceVC.PIZipCode.text;
    patient.piPhoneNumber = insuranceVC.PIPhoneNum.text;
    patient.piEmail = insuranceVC.PIEmail.text;
    
    patient.sInsuranceName = insuranceVC.secondaryInsuranceName.text;
    patient.sPolicyNumber = insuranceVC.secondaryInsurancePolicyNum.text;
    patient.sGroupNumber = insuranceVC.secondaryInsuranceGroupNum.text;
    
    patient.srelationshipToPrimaryInsured = insuranceVC.relationshipToSecondaryInsuree.text;
    patient.sPiFirstName = insuranceVC.SIFirstName.text;
    patient.sPiMiddleName = insuranceVC.SIMiddleName.text;
    patient.sPiPaternalLastName = insuranceVC.SIPaternalLastName.text;
    patient.sPiMaternalLastName = insuranceVC.SIMaternalLastName.text;
    patient.sPiDateOfBirth = insuranceVC.SIDateofBirth.text;
    patient.sPiSocialSecurityNumber = insuranceVC.SISocialSecurityNum.text;
    patient.sPiLine1 = insuranceVC.SIAddressLine1.text;
    patient.sPiLine2 = insuranceVC.SIAddressLine2.text;
    patient.sPiState = insuranceVC.SIState.text;
    patient.sPiCity = insuranceVC.SICity.text;
    patient.sPiZip = insuranceVC.SIZipCode.text;
    patient.sPiPhoneNumber = insuranceVC.SIPhoneNum.text;
    patient.sPiEmail = insuranceVC.SIEmail.text;
    
    
    //Save the information using the context
    NSError *saveError = nil;
    
    [self.managedObjectContext save:&saveError];
    
    NSLog(@"Added a new Patient!");
    
    // Return the logged-in doctor
    HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    hvc.myDoctor = self.myDoctor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.selectedViewController = [[self viewControllers] objectAtIndex:1];
    self.selectedViewController = [[self viewControllers] objectAtIndex:2];
    self.selectedViewController = [[self viewControllers] objectAtIndex:3];
    self.selectedViewController = [[self viewControllers] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
