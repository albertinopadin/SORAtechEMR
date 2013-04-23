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
#import "Condition.h"
#import "Medicine.h"
#import "NPMedicinesViewController.h"

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

- (NSNumber *)getMaxId
{
    //NSNumber *nextId=[NSNumber numberWithInt:1];
    
    NSNumber *nextId;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"PRIMARYKEY" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"_pk"];
    NSExpression *maxIdExpression = [NSExpression expressionForFunction:@"max:"
                                                              arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxId"];
    [expressionDescription setExpression:maxIdExpression];
    //[expressionDescription setExpression:keyPathExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        NSLog(@"error getting max id");
        
    }
    else
    {
        nextId = (NSNumber*)[[fetchedObjects lastObject] objectForKey:@"maxId"];
        int nxt = [nextId intValue] + 1;
        nextId = [NSNumber numberWithInt:nxt];
    }
    
    return nextId;
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

    // Get patient list
    //Create fetch request for the Patient entity table
//    NSFetchRequest *patientListFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
//    
//    //Execute the fetch request through the managed object context to get the patient list
//    self.patientList = [self.managedObjectContext executeFetchRequest:patientListFetchRequest error:nil];
//    
//    //Insert a new patient in the patient table
//    patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    
    // Personal Information from first vc:
//    patient.firstName = personalVC.firstName.text;
//    patient.middleName = personalVC.middleName.text;
//    patient.paternalLastName = personalVC.paternalLastName.text;
//    patient.maternalLastName = personalVC.maternalLastName.text;
//    patient.socialSecurityNumber = personalVC.socialSecurity.text;
//    patient.line1 = personalVC.addressLine1.text;
//    patient.line2 = personalVC.addressLine2.text;
//    patient.state = personalVC.state.text;
//    patient.city = personalVC.city.text;
//    patient.zip = personalVC.zipCode.text;
//    
//    patient.dateOfBirth = personalVC.dateOfBirth.text;
//    patient.phoneNumber = personalVC.phoneNumber.text;
//    patient.email = personalVC.email.text;
//    
//    //patient.patientId = [NSNumber numberWithInt:self.patientList.count + 1];
//    //patient.patientId = [self getMaxId];

    // Employer Info from second vc:
//    patient.empName = contactsVC.employerName.text;
//    patient.empLine1 = contactsVC.employerAddressLine1.text;
//    patient.empLine2 = contactsVC.employerAddressLine2.text;
//    patient.empCity = contactsVC.employerCity.text;
//    patient.empState = contactsVC.employerState.text;
//    patient.empZip = contactsVC.employerZipCode.text;
//    patient.empPhoneNumber = contactsVC.employerPhoneNumber.text;
//    patient.empEmail = contactsVC.employerEmail.text;
//    
//    
//    // Emergency Contact Info from second vc:
//    patient.emeFirstName = contactsVC.emergencyCFirstName.text;
//    patient.emeMiddleName = contactsVC.emergencyCMiddleName.text;
//    patient.emePaternalLastName = contactsVC.emergencyCPaternalLastName.text;
//    patient.emeMaternalLastName = contactsVC.emergencyCMaternalLastName.text;
//    patient.emeLine1 = contactsVC.emergencyCAddressLine1.text;
//    patient.emeLine2 = contactsVC.emergencyCAddressLine2.text;
//    patient.emeCity = contactsVC.emergencyCCity.text;
//    patient.emeState = contactsVC.emergencyCState.text;
//    patient.emeZip = contactsVC.emergencyCZipCode.text;
//    patient.emePhoneNumber = contactsVC.emergencyCPhoneNumber.text;
//    patient.emeEmail = contactsVC.emergencyCEmail.text;

    // Insurance Info from third vc:
//    patient.insuranceName = insuranceVC.primaryInsuranceName.text;
//    patient.policyNumber = insuranceVC.primaryInsurancePolicyNum.text;
//    patient.groupNumber = insuranceVC.primaryInsuranceGroupNum.text;
//    
//    patient.relationshipToPrimaryInsured = insuranceVC.relationshipToPrimaryInsuree.text;
//    patient.piFirstName = insuranceVC.PIFirstName.text;
//    patient.piMiddleName = insuranceVC.PIMiddleName.text;
//    patient.piPaternalLastName = insuranceVC.PIPaternalLastName.text;
//    patient.piMaternalLastName = insuranceVC.PIMaternalLastName.text;
//    patient.piDateOfBirth = insuranceVC.PIDateofBirth.text;
//    patient.piSocialSecurityNumber = insuranceVC.PISocialSecurityNum.text;
//    patient.piLine1 = insuranceVC.PIAddressLine1.text;
//    patient.piLine2 = insuranceVC.PIAddressLine2.text;
//    patient.piState = insuranceVC.PIState.text;
//    patient.piCity = insuranceVC.PICity.text;
//    patient.piZip = insuranceVC.PIZipCode.text;
//    patient.piPhoneNumber = insuranceVC.PIPhoneNum.text;
//    patient.piEmail = insuranceVC.PIEmail.text;
//    
//    patient.sInsuranceName = insuranceVC.secondaryInsuranceName.text;
//    patient.sPolicyNumber = insuranceVC.secondaryInsurancePolicyNum.text;
//    patient.sGroupNumber = insuranceVC.secondaryInsuranceGroupNum.text;
//    
//    patient.srelationshipToPrimaryInsured = insuranceVC.relationshipToSecondaryInsuree.text;
//    patient.sPiFirstName = insuranceVC.SIFirstName.text;
//    patient.sPiMiddleName = insuranceVC.SIMiddleName.text;
//    patient.sPiPaternalLastName = insuranceVC.SIPaternalLastName.text;
//    patient.sPiMaternalLastName = insuranceVC.SIMaternalLastName.text;
//    patient.sPiDateOfBirth = insuranceVC.SIDateofBirth.text;
//    patient.sPiSocialSecurityNumber = insuranceVC.SISocialSecurityNum.text;
//    patient.sPiLine1 = insuranceVC.SIAddressLine1.text;
//    patient.sPiLine2 = insuranceVC.SIAddressLine2.text;
//    patient.sPiState = insuranceVC.SIState.text;
//    patient.sPiCity = insuranceVC.SICity.text;
//    patient.sPiZip = insuranceVC.SIZipCode.text;
//    patient.sPiPhoneNumber = insuranceVC.SIPhoneNum.text;
//    patient.sPiEmail = insuranceVC.SIEmail.text;
    

    
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
                                
                                insuranceVC.relationshipToSecondaryInsuree.text, @"secondaryInsuranceRelationshipToPrimaryInsured",
                                
                                nil];
    
    // Create the json object
    NSError *error = nil;
    
    NSData *newPatientJSONData = [NSJSONSerialization dataWithJSONObject:newPatient options:NSJSONWritingPrettyPrinted error:&error];
    
    // Send the new patient in json to server
    NSURL *url = [NSURL URLWithString:@"http://services.soratech.cardona150.com/emr/patients/?key=e8342f8b-c73c-44c9-bd19-327b54c9ed65"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", newPatientJSONData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:newPatientJSONData];
    
    // Response
    NSURLResponse *response = nil;
    NSError *responseError = nil;
    
    NSData *responseResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    if (responseError == nil)
    {
        HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        hvc.myDoctor = self.myDoctor;
        [hvc incomingSegue:@"fromNewPatientPage"];
    }
    else
    {
        //Display a message if the request failed:
        UIAlertView *requestFailedAlert = [[UIAlertView alloc] initWithTitle:@"RequestFailed" message:@"The server could not add the new patient." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [requestFailedAlert show];
    }
        
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
    
    // Return the logged-in doctor
//    HomeViewController *hvc = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
//    hvc.myDoctor = self.myDoctor;
//    [hvc incomingSegue:@"fromNewPatientPage"];
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
