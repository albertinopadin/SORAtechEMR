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
#import "NPContactsViewController.h"
#import "NPInsuranceViewController.h"
#import "HomeViewController.h"
#import "NPConditionsViewController.h"
#import "NPMedicinesViewController.h"
#import "KeychainItemWrapper.h"

@interface NewPatientTBViewController ()

@property (strong, nonatomic) NSArray *vcArray;
@property (strong, nonatomic) NSArray *patientList;

@end

@implementation NewPatientTBViewController

@synthesize vcArray, patientList;

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
    NPContactsViewController *contactsVC = [self.vcArray objectAtIndex:1];
    NPInsuranceViewController *insuranceVC = [self.vcArray objectAtIndex:2];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Get each view controller from my array of vc's
    self.vcArray = [self viewControllers];
    PatientPersonalInfoViewController *personalVC = [self.vcArray objectAtIndex:0];
    NPContactsViewController *contactsVC = [self.vcArray objectAtIndex:1];
    NPInsuranceViewController *insuranceVC = [self.vcArray objectAtIndex:2];
    NPConditionsViewController *conditionsVC = [self.vcArray objectAtIndex:3];
    NPMedicinesViewController *medicinesVC = [self.vcArray objectAtIndex:4];

    
    //Get the patient information
    NSDictionary *newPatient = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
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
    
    // Create the json object
    NSError *error = nil;
    
    NSData *newPatientJSONData = [NSJSONSerialization dataWithJSONObject:newPatient options:NSJSONWritingPrettyPrinted error:&error];
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    //NSLog(@"Adding new patient; user's key is: %@", key);
    // Send the new patient in json to server
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/?key=%@", key]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", newPatientJSONData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:newPatientJSONData];
    
    // Response
    //NSURLResponse *response = nil;
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    NSData *responseResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    //[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    
    NSString *responseData = [[NSString alloc] initWithData:responseResult encoding:NSUTF8StringEncoding];
    
    NSLog(@"responseData is: %@", responseData);
    NSLog(@"Response satus code: %i", [response statusCode]);
    
    /*
    if (responseError == nil)
    {
        HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [hvc incomingSegue:@"fromNewPatientPage"];
    }
    else
    {
        //Display a message if the request failed:
        UIAlertView *requestFailedAlert = [[UIAlertView alloc] initWithTitle:@"RequestFailed" message:@"The server could not add the new patient." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [requestFailedAlert show];
    }
    */
    
    ////////////////////////////////////////////////////////////////////////
    // GET ALL PATIENTS AND DETERMINE MAX ID -> THIS IS THE PATIENT YOU JUST ADDED
    
    NSError *getError, *ge = nil;
    NSHTTPURLResponse *getResponse = nil;
    
    NSURLRequest *patientGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/?key=%@", key]]];
    
    NSData *patientGetData = [NSURLConnection sendSynchronousRequest:patientGetRequest returningResponse:&getResponse error:&ge];
    
    NSLog(@"Response for patients get is: %i", [getResponse statusCode]);
    
    if (!patientGetData) {
        NSLog(@"patientGetData is nil");
        NSLog(@"Error: %@", ge);
    }
    
    //Creates the array of dictionary objects, ordered alphabetically
    // Each element in this array is a patient object, whose properties can be accessed as a dictionary
    NSArray *patients = [NSJSONSerialization JSONObjectWithData:patientGetData options:0 error:&getError];
    
    // Last patient in the array should be max id
    NSDictionary *lastPatient = [patients objectAtIndex:patients.count-1];
    
    // Conditions from fourth vc:
    NSArray *conditions = [conditionsVC textConditionsList];
    
    // Create the json object
    NSError *cError = nil;
    
    // Have to get the patient id back from the new patient insert response
    NSURL *cUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/conditions/?key=%@", [lastPatient valueForKey:@"patientId"], key]];
    
    NSLog(@"cUrl: %@", cUrl);
    
    NSMutableURLRequest *cRequest = [NSMutableURLRequest requestWithURL:cUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [cRequest setHTTPMethod:@"PUT"];
    [cRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [cRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    // Response
    NSHTTPURLResponse *cResponse = nil;
    NSError *cResponseError = nil;
    
    for (NSString *s in conditions)
    {
        if (s.length > 0)
        {
            // Insert new condition
            NSDictionary *condition = [[NSDictionary alloc] initWithObjectsAndKeys:s, @"condition", nil];
            
            NSData *conditionJSONData = [NSJSONSerialization dataWithJSONObject:condition options:NSJSONWritingPrettyPrinted error:&cError];
            [cRequest setValue:[NSString stringWithFormat:@"%d", conditionJSONData.length] forHTTPHeaderField:@"Content-Length"];
            [cRequest setHTTPBody:conditionJSONData];
            
            [NSURLConnection sendSynchronousRequest:cRequest returningResponse:&cResponse error:&cResponseError];
            NSLog(@"Response satus code: %i", [cResponse statusCode]);
        }
    }
    

    // Medicines from fifth vc:
    [medicinesVC saveMedications:[[lastPatient valueForKey:@"patientId"] integerValue]];
    
    NSLog(@"New patient pid: %i", [[lastPatient valueForKey:@"patientId"] integerValue]);
    
    if (responseError == nil && cResponseError == nil)
    {
        HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [hvc incomingSegue:@"fromNewPatientPage"];
    }
    else
    {
        //Display a message if the request failed:
        UIAlertView *requestFailedAlert = [[UIAlertView alloc] initWithTitle:@"RequestFailed" message:@"The server could not add the new patient." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [requestFailedAlert show];
    }
    
    
    
    /*
    
    //Save the patient information using the context
//    NSError *saveError = nil;
//    
//    [self.managedObjectContext save:&saveError];
//    
//    NSLog(@"Added a new Patient! With id: %@", patient.patientId);
//    
//    // Conditions from fourth vc:
//    NSArray *conditions = [conditionsVC textConditionsList];
//    
//    for (NSString *s in conditions)
//    {
//        if (s.length > 0)
//        {
//            // Insert new condition
//            Condition *c = [NSEntityDescription insertNewObjectForEntityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
//            c.patientId = patient.patientId;
//            c.conditionName = s;
//            
//            [self.managedObjectContext save:&saveError];
//        }
//        
//    }
//
//    // Medications from fifth vc:
//    [medicinesVC saveMedications:patient.patientId];
//    
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.selectedViewController = [[self viewControllers] objectAtIndex:1];
    self.selectedViewController = [[self viewControllers] objectAtIndex:2];
    self.selectedViewController = [[self viewControllers] objectAtIndex:3];
    self.selectedViewController = [[self viewControllers] objectAtIndex:4];
    self.selectedViewController = [[self viewControllers] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
