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
#import "NPContactsViewController.h"
#import "NPInsuranceViewController.h"
#import "PatientInfoTableViewController.h"
#import "EditConditionsViewController.h"
#import "EditMedicinesViewController.h"
#import "KeychainItemWrapper.h"

@interface EditPatientTBViewController ()
//@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) NSArray *vcArray;
@property (strong, nonatomic) NSArray *patientList;

@property (strong, nonatomic) PatientPersonalInfoViewController *personalVC;
@property (strong, nonatomic) NPContactsViewController *contactsVC;
@property (strong, nonatomic) NPInsuranceViewController *insuranceVC;
@property (strong, nonatomic) EditConditionsViewController *conditionsVC;
@property (strong, nonatomic) EditMedicinesViewController *medicinesVC;

@end

@implementation EditPatientTBViewController

@synthesize myPatientJSON;

@synthesize vcArray, patientList, personalVC, contactsVC, insuranceVC;

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
        NSArray *vcs = [self.navigationController viewControllers];
        NSInteger numVCs = vcs.count;
        PatientInfoTableViewController *pitvc = [vcs objectAtIndex:numVCs - 2];
        pitvc.myPatientJSON = self.myPatientJSON;
        //[pitvc.myTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Checks if there are empty text fields
- (BOOL)shouldPerformPop
{
    if (![personalVC namesPresent])
    {
        //Display a message if the first name, paternal or maternal last names are empty:
        UIAlertView *nameTextBoxesAreEmptyAlert = [[UIAlertView alloc] initWithTitle:@"Empty Name Fields" message:@"You must enter at least the first name and paternal and maternal last names to save a patient in the system." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [nameTextBoxesAreEmptyAlert show];
        
        return NO;
    }
    
    if ([personalVC textFieldEmpty] || [contactsVC textFieldEmpty] || [insuranceVC textFieldEmpty])
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
    /*
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
    self.myPatient.empName = contactsVC.employerName.text;
    self.myPatient.empLine1 = contactsVC.employerAddressLine1.text;
    self.myPatient.empLine2 = contactsVC.employerAddressLine2.text;
    self.myPatient.empCity = contactsVC.employerCity.text;
    self.myPatient.empState = contactsVC.employerState.text;
    self.myPatient.empZip = contactsVC.employerZipCode.text;
    self.myPatient.empPhoneNumber = contactsVC.employerPhoneNumber.text;
    self.myPatient.empEmail = contactsVC.employerEmail.text;
    
    
    // Emergency Contact Info from second vc:
    self.myPatient.emeFirstName = contactsVC.emergencyCFirstName.text;
    self.myPatient.emeMiddleName = contactsVC.emergencyCMiddleName.text;
    self.myPatient.emePaternalLastName = contactsVC.emergencyCPaternalLastName.text;
    self.myPatient.emeMaternalLastName = contactsVC.emergencyCMaternalLastName.text;
    self.myPatient.emeLine1 = contactsVC.emergencyCAddressLine1.text;
    self.myPatient.emeLine2 = contactsVC.emergencyCAddressLine2.text;
    self.myPatient.emeCity = contactsVC.emergencyCCity.text;
    self.myPatient.emeState = contactsVC.emergencyCState.text;
    self.myPatient.emeZip = contactsVC.emergencyCZipCode.text;
    self.myPatient.emePhoneNumber = contactsVC.emergencyCPhoneNumber.text;
    self.myPatient.emeEmail = contactsVC.emergencyCEmail.text;
    
    
    // Insurance Info from third vc:
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
    */
    
    //Get the patient information
    
    // Have to see if better do this with the existing patient json (self.myPatientJSON)
    //[myPatientJSON setValue:<#(id)#> forKey:<#(NSString *)#>]
    
    NSDictionary *editedPatient = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
                                // Set the patient id
                                [self.myPatientJSON valueForKey:@"patientId"], @"patientId",
                                   
                                // Personal Information from first vc:
                                personalVC.firstName.text, @"firstName",
                                personalVC.middleName.text, @"middleName",
                                personalVC.paternalLastName.text, @"paternalLastName",
                                personalVC.maternalLastName.text, @"maternalLastName",
                                personalVC.addressLine1.text, @"addressLine1",
                                personalVC.addressLine2.text, @"addressLine2",
                                personalVC.city.text, @"addressCity",
                                personalVC.state.text, @"addressState",
                                personalVC.zipCode.text, @"addressZip",
                                personalVC.phoneNumber.text, @"phoneNumber",
                                personalVC.email.text, @"email",
                                personalVC.dateOfBirth.text, @"dateOfBirth",
                                personalVC.socialSecurity.text, @"socialSecurityNumber",
                                
                                // Employer Info from second vc:
                                contactsVC.employerName.text, @"employerName",
                                contactsVC.employerAddressLine1.text, @"employerAddressLine1",
                                contactsVC.employerAddressLine2.text, @"employerAddressLine2",
                                contactsVC.employerCity.text, @"employerAddressCity",
                                contactsVC.employerState.text, @"employerAddressState",
                                contactsVC.employerZipCode.text, @"employerAddressZip",
                                contactsVC.employerPhoneNumber.text, @"employerPhoneNumber",
                                contactsVC.employerEmail.text, @"employerEmail",
                                
                                // Emergency Contact Info from second vc:
                                contactsVC.emergencyCFirstName.text, @"emergencyContactFirstName",
                                contactsVC.emergencyCMiddleName.text, @"emergencyContactMiddleName",
                                contactsVC.emergencyCPaternalLastName.text, @"emergencyContactPaternalLastName",
                                contactsVC.emergencyCMaternalLastName.text, @"emergencyContactMaternalLastName",
                                contactsVC.emergencyCAddressLine1.text, @"emergencyContactAddressLine1",
                                contactsVC.emergencyCAddressLine2.text, @"emergencyContactAddressLine2",
                                contactsVC.emergencyCCity.text, @"emergencyContactAddressCity",
                                contactsVC.emergencyCState.text, @"emergencyContactAddressState",
                                contactsVC.emergencyCZipCode.text, @"emergencyContactAddressZip",
                                contactsVC.emergencyCPhoneNumber.text, @"emergencyContactPhoneNumber",
                                contactsVC.emergencyCEmail.text, @"emergencyContactEmail",
                                
                                // Insurance Info from third vc:
                                insuranceVC.primaryInsuranceName.text, @"primaryInsuranceName",
                                insuranceVC.primaryInsurancePolicyNum.text, @"primaryInsurancePolicyNumber",
                                insuranceVC.primaryInsuranceGroupNum.text, @"primaryInsuranceGroupNumber",
                                insuranceVC.PIFirstName.text, @"primaryInsurancePrimaryInsuredFirstName",
                                insuranceVC.PIMiddleName.text, @"primaryInsurancePrimaryInsuredMiddleName",
                                insuranceVC.PIPaternalLastName.text, @"primaryInsurancePrimaryInsuredPaternalLastName",
                                insuranceVC.PIMaternalLastName.text, @"primaryInsurancePrimaryInsuredMaternalLastName",
                                insuranceVC.PIAddressLine1.text, @"primaryInsurancePrimaryInsuredAddressLine1",
                                insuranceVC.PIAddressLine2.text, @"primaryInsurancePrimaryInsuredAddressLine2",
                                insuranceVC.PICity.text, @"primaryInsurancePrimaryInsuredAddressCity",
                                insuranceVC.PIState.text, @"primaryInsurancePrimaryInsuredAddressState",
                                insuranceVC.PIZipCode.text, @"primaryInsurancePrimaryInsuredAddressZip",
                                insuranceVC.PIPhoneNum.text, @"primaryInsurancePrimaryInsuredPhoneNumber",
                                insuranceVC.PIEmail.text, @"primaryInsurancePrimaryInsuredEmail",
                                insuranceVC.PIDateofBirth.text, @"primaryInsurancePrimaryInsuredDateOfBirth",
                                insuranceVC.PISocialSecurityNum.text, @"primaryInsurancePrimaryInsuredSocialSecurityNumber",
                                
                                //                                insuranceVC.PIEmployerName.text, @"primaryInsurancePrimaryInsuredEmployerName",
                                //                                insuranceVC.PIEmployerAddressLine1.text, @"primaryInsurancePrimaryInsuredEmployerAddressLine1",
                                //                                insuranceVC.PIEmployerAddressLine2.text, @"primaryInsurancePrimaryInsuredEmployerAddressLine2",
                                //                                insuranceVC.PIEmployerCity.text, @"primaryInsurancePrimaryInsuredEmployerAddressCity",
                                //                                insuranceVC.PIEmployerState.text, @"primaryInsurancePrimaryInsuredEmployerAddressState",
                                //                                insuranceVC.PIEmployerZip.text, @"primaryInsurancePrimaryInsuredEmployerAddressZip",
                                //                                insuranceVC.PIEmployerPhoneNumber.text, @"primaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                //                                insuranceVC.PIEmployerEmail.text, @"primaryInsurancePrimaryInsuredEmployerEmail",
                                
                                   @"", @"primaryInsurancePrimaryInsuredEmployerName",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerAddressLine1",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerAddressLine2",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerAddressCity",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerAddressState",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerAddressZip",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                   @"", @"primaryInsurancePrimaryInsuredEmployerEmail",
                                   
                                   
                                insuranceVC.relationshipToPrimaryInsuree.text, @"primaryInsuranceRelationshipToPrimaryInsured",
                                
                                
                                insuranceVC.secondaryInsuranceName.text, @"secondaryInsuranceName",
                                insuranceVC.secondaryInsurancePolicyNum.text, @"secondaryInsurancePolicyNumber",
                                insuranceVC.secondaryInsuranceGroupNum.text, @"secondaryInsuranceGroupNumber",
                                insuranceVC.SIFirstName.text, @"secondaryInsurancePrimaryInsuredFirstName",
                                insuranceVC.SIMiddleName.text, @"secondaryInsurancePrimaryInsuredMiddleName",
                                insuranceVC.SIPaternalLastName.text, @"secondaryInsurancePrimaryInsuredPaternalLastName",
                                insuranceVC.SIMaternalLastName.text, @"secondaryInsurancePrimaryInsuredMaternalLastName",
                                insuranceVC.SIAddressLine1.text, @"secondaryInsurancePrimaryInsuredAddressLine1",
                                insuranceVC.SIAddressLine2.text, @"secondaryInsurancePrimaryInsuredAddressLine2",
                                insuranceVC.SICity.text, @"secondaryInsurancePrimaryInsuredAddressCity",
                                insuranceVC.SIState.text, @"secondaryInsurancePrimaryInsuredAddressState",
                                insuranceVC.SIZipCode.text, @"secondaryInsurancePrimaryInsuredAddressZip",
                                insuranceVC.SIPhoneNum.text, @"secondaryInsurancePrimaryInsuredPhoneNumber",
                                insuranceVC.SIEmail.text, @"secondaryInsurancePrimaryInsuredEmail",
                                insuranceVC.SIDateofBirth.text, @"secondaryInsurancePrimaryInsuredDateOfBirth",
                                insuranceVC.SISocialSecurityNum.text, @"secondaryInsurancePrimaryInsuredSocialSecurityNumber",
                                
                                //                                insuranceVC.SIEmployerName.text, @"secondaryInsurancePrimaryInsuredEmployerName",
                                //                                insuranceVC.SIEmployerAddressLine1.text, @"secondaryInsurancePrimaryInsuredEmployerAddressLine1",
                                //                                insuranceVC.SIEmployerAddressLine2.text, @"secondaryInsurancePrimaryInsuredEmployerAddressLine2",
                                //                                insuranceVC.SIEmployerCity.text, @"secondaryInsurancePrimaryInsuredEmployerAddressCity",
                                //                                insuranceVC.SIEmployerState.text, @"secondaryInsurancePrimaryInsuredEmployerAddressState",
                                //                                insuranceVC.SIEmployerZip.text, @"secondaryInsurancePrimaryInsuredEmployerAddressZip",
                                //                                insuranceVC.SIEmployerPhoneNumber.text, @"secondaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                //                                insuranceVC.SIEmployerEmail.text, @"secondaryInsurancePrimaryInsuredEmployerEmail",
                                
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerName",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerAddressLine1",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerAddressLine2",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerAddressCity",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerAddressState",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerAddressZip",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                   @"", @"secondaryInsurancePrimaryInsuredEmployerEmail",

                                   
                                insuranceVC.relationshipToSecondaryInsuree.text, @"secondaryInsuranceRelationshipToPrimaryInsured",
                                
                                nil];
    // Testing json to be sent:
    NSLog(@"editedPatient JSON: %@", editedPatient);
    
    
    // Create the json object
    NSError *error = nil;
    
    NSData *editedPatientJSONData = [NSJSONSerialization dataWithJSONObject:editedPatient options:NSJSONWritingPrettyPrinted error:&error];
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    //NSLog(@"Adding new patient; user's key is: %@", key);
    // Send the new patient in json to server
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], key]];
    
    // Check url
    NSLog(@"Post URL = %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    // HTTP METHOD: POST (EDIT)
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", editedPatientJSONData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:editedPatientJSONData];
    
    // Response
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    //NSData *responseResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    
    NSLog(@"Response satus code: %i", [response statusCode]);
    
    // Save conditions
    [self.conditionsVC saveEditedConditionsWithPID:[[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
    
    // Save medications
    [self.medicinesVC saveEditedMedicinesWithPID:[[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    // GET THE EDITED PATIENT FROM THE DB, TO MAKE SURE WE HAVE UPDATED THE INFO IN THE DB
    
    
    NSError *getError, *getError2, *getError3 = nil;
    //NSURLResponse *response = nil;
    NSHTTPURLResponse *getResponse = nil;
    
    // Get the JSON for the specific edited patient from the db
    NSURLRequest *patientGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%@/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], key]]];
    
    NSData *patientGetData = [NSURLConnection sendSynchronousRequest:patientGetRequest returningResponse:&getResponse error:&getError2];
    
    NSLog(@"Response for edited patients get is: %i", [getResponse statusCode]);
    
    if (!patientGetData) {
        NSLog(@"patientGetData is nil");
        NSLog(@"Error: %@", getError3);
    }
    
    // Should have only one element in the json array, which is the edited patient's dictionary
    NSArray *editedArr = [NSJSONSerialization JSONObjectWithData:patientGetData options:0 error:&getError];
    
    self.myPatientJSON = [editedArr objectAtIndex:0];
//    self.myPatientJSON = [[NSJSONSerialization JSONObjectWithData:patientGetData options:0 error:&getError] objectAtIndex:0];
    
    //NSLog(@"editedArr count: %i", [editedArr count]);
    NSLog(@"Edited Patient!");
    
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
    self.selectedViewController = [[self viewControllers] objectAtIndex:4];
    self.selectedViewController = [[self viewControllers] objectAtIndex:0];
    
    self.personalVC = [self.vcArray objectAtIndex:0];
    self.contactsVC = [self.vcArray objectAtIndex:1];
    self.insuranceVC = [self.vcArray objectAtIndex:2];
    self.conditionsVC = [self.vcArray objectAtIndex:3];
    self.medicinesVC = [self.vcArray objectAtIndex:4];
    
    
    // Put current saved info:
    
    // Personal Information in first vc:
    personalVC.firstName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"firstName"]];
    personalVC.middleName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"middleName"]];
    personalVC.paternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"paternalLastName"]];
    personalVC.maternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"maternalLastName"]];
    personalVC.socialSecurity.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"socialSecurityNumber"]];
    personalVC.addressLine1.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"addressLine1"]];
    personalVC.addressLine2.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"addressLine2"]];
    personalVC.state.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"addressState"]];
    personalVC.city.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"addressCity"]];
    personalVC.zipCode.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"addressZip"]];
    
    personalVC.dateOfBirth.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"dateOfBirth"]];
    personalVC.phoneNumber.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"phoneNumber"]];
    personalVC.email.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"email"]];
    
    
    // Employer Info in second vc:
    contactsVC.employerName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerName"]];
    contactsVC.employerAddressLine1.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressLine1"]];;
    contactsVC.employerAddressLine2.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressLine2"]];;
    contactsVC.employerCity.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressCity"]];;
    contactsVC.employerState.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressState"]];;
    contactsVC.employerZipCode.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressZip"]];;
    contactsVC.employerPhoneNumber.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerPhoneNumber"]];;
    contactsVC.employerEmail.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerEmail"]];;
    
    
    // Emergency Contact Info in third vc:
    contactsVC.emergencyCFirstName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactFirstName"]];
    contactsVC.emergencyCMiddleName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactMiddleName"]];
    contactsVC.emergencyCPaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactPaternalLastName"]];
    contactsVC.emergencyCMaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactMaternalLastName"]];
    contactsVC.emergencyCAddressLine1.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressLine1"]];
    contactsVC.emergencyCAddressLine2.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressLine2"]];
    contactsVC.emergencyCCity.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressCity"]];
    contactsVC.emergencyCState.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressState"]];
    contactsVC.emergencyCZipCode.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressZip"]];
    contactsVC.emergencyCPhoneNumber.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactPhoneNumber"]];
    contactsVC.emergencyCEmail.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactEmail"]];
    
    
    // Insurance Info in fourth vc:
    insuranceVC.primaryInsuranceName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceName"]];
    insuranceVC.primaryInsurancePolicyNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePolicyNumber"]];
    insuranceVC.primaryInsuranceGroupNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceGroupNumber"]];
    
    insuranceVC.relationshipToPrimaryInsuree.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceRelationshipToPrimaryInsured"]];
    insuranceVC.PIFirstName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredFirstName"]];
    insuranceVC.PIMiddleName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredMiddleName"]];
    insuranceVC.PIPaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredPaternalLastName"]];
    insuranceVC.PIMaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredMaternalLastName"]];
    insuranceVC.PIDateofBirth.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredDateOfBirth"]];
    insuranceVC.PISocialSecurityNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredSocialSecurityNumber"]];
    insuranceVC.PIAddressLine1.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine1"]];
    insuranceVC.PIAddressLine2.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine2"]];
    insuranceVC.PIState.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressState"]];
    insuranceVC.PICity.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressCity"]];
    insuranceVC.PIZipCode.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressZip"]];
    insuranceVC.PIPhoneNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredPhoneNumber"]];
    insuranceVC.PIEmail.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredEmail"]];
    
    insuranceVC.secondaryInsuranceName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceName"]];
    insuranceVC.secondaryInsurancePolicyNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePolicyNumber"]];
    insuranceVC.secondaryInsuranceGroupNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceGroupNumber"]];
    
    insuranceVC.relationshipToSecondaryInsuree.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceRelationshipToPrimaryInsured"]];
    insuranceVC.SIFirstName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredFirstName"]];
    insuranceVC.SIMiddleName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMiddleName"]];
    insuranceVC.SIPaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPaternalLastName"]];
    insuranceVC.SIMaternalLastName.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMaternalLastName"]];
    insuranceVC.SIDateofBirth.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredDateOfBirth"]];
    insuranceVC.SISocialSecurityNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredSocialSecurityNumber"]];
    insuranceVC.SIAddressLine1.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine1"]];
    insuranceVC.SIAddressLine2.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine2"]];
    insuranceVC.SIState.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressState"]];
    insuranceVC.SICity.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressCity"]];
    insuranceVC.SIZipCode.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressZip"]];
    insuranceVC.SIPhoneNum.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPhoneNumber"]];
    insuranceVC.SIEmail.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredEmail"]];
    
    
    // Generate conditions and medications on the last two vc's
    [self.conditionsVC generateConditionsList:[[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
    
    [self.medicinesVC generateMedicineList:[[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
}

- (NSString *)verifyForNull:(id)theString
{
    NSString *returnString = [theString isEqual:[NSNull null]] ? @"" : theString;
    return returnString;
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
        // First we send the request to edit the patient to the db and get the edited patient's info back
        [self preparePatientEdit];
        NSArray *vcs = [self.navigationController viewControllers];
        NSInteger numVCs = vcs.count;
        PatientInfoTableViewController *pitvc = [vcs objectAtIndex:numVCs - 2];
        pitvc.myPatientJSON = self.myPatientJSON;
        //[pitvc.myTableView reloadData];
        // Pop to previous vc:
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
