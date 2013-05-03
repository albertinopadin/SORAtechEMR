//
//  PatientInfoTableViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/20/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientInfoTableViewController.h"
#import "STAppDelegate.h"

#import "Medicine.h"
#import "PIPInsureeViewController.h"
#import "SIPInsureeViewController.h"
#import "EditPatientTBViewController.h"
#import "BTCopyToSMViewController.h"
#import "KeychainItemWrapper.h"

@interface PatientInfoTableViewController ()

@end

@implementation PatientInfoTableViewController

@synthesize myPatientJSON;

@synthesize myTableView, medicineCells;

@synthesize visitList, medicineList, conditionList;

@synthesize fullNameLabel, addressLine1Label, addressLine2Label, phoneNumberLabel, emailLabel, dateOfBirthLabel, socialSecurityLabel;

@synthesize employerNameLabel, employerAddressLine1Label, employerAddressLine2Label, employerPhoneNumberLabel, employerEmailLabel;

@synthesize emergencyCNameLabel, emergencyCAddressLine1Label, emergencyCAddressLine2Label, emergencyCPhoneNumberLabel, emergencyCEmailLabel;

@synthesize primaryInsuranceNameLabel, primaryInsurancePolicyNumLabel, primaryInsuranceGroupNumLabel, primaryInsuranceRelationshipToPrimaryLabel;

@synthesize secondaryInsuranceNameLabel, secondaryInsurancePolicyNumLabel, secondaryInsuranceGroupNumLabel, secondaryInsuranceRelationshipToPrimaryLabel;


//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PIPInsureeSegue1"] || [segue.identifier isEqualToString:@"PIPInsureeSegue2"])
    {
        PIPInsureeViewController *pipVC = segue.destinationViewController;
        //pipVC.myPatient = self.myPatient;
    }
    else if ([segue.identifier isEqualToString:@"SIPInsureeSegue1"] || [segue.identifier isEqualToString:@"SIPInsureeSegue2"])
    {
        SIPInsureeViewController *sipVC = segue.destinationViewController;
        //sipVC.myPatient = self.myPatient;
    }
    else if ([segue.identifier isEqualToString:@"editPatientInfoSegue"])
    {
        EditPatientTBViewController *edVC = segue.destinationViewController;
        edVC.myPatientJSON = self.myPatientJSON;
    }
    else if ([[segue identifier] isEqualToString:@"BluetoothCopyPatientInfoSegue"])
    {
        BTCopyToSMViewController *btVC = segue.destinationViewController;
        btVC.myPatientJSON = self.myPatientJSON;
    }
}


// When user pops back from editing patient info reload the table's data:
- (void)viewWillAppear:(BOOL)animated
{
    // Have to call viewDidLoad because part of the table view is static and thus will not reload.
    [self viewDidLoad];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    /*
     
    // NSFetchRequest
    NSFetchRequest *condFetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *condEntity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
    
    [condFetchRequest setEntity:condEntity];
    
    NSPredicate *condPredicate;
    
    // Set predicate so it searches for our particular patient's visits.
    condPredicate =[NSPredicate predicateWithFormat:@"patientId == %@", self.myPatient.patientId];
    
    [condFetchRequest setPredicate:condPredicate];
    
    self.conditionList = [self.managedObjectContext executeFetchRequest:condFetchRequest error:nil];
    /////////////////////////////////////
    
    // NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    // Set predicate so it searches for our particular patient's visits.
    predicate =[NSPredicate predicateWithFormat:@"patientId == %@", self.myPatient.patientId];
    
    [fetchRequest setPredicate:predicate];
    
    self.visitList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    ////////////////////////////////////////
    
    self.medicineList = [[NSArray alloc] init];
    
    // NSFetchRequest
    NSFetchRequest *medFetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *medEntity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
    
    [medFetchRequest setEntity:medEntity];
    
    NSPredicate *medPredicate;
        
    // Set predicate to search meds with patientId
    medPredicate =[NSPredicate predicateWithFormat:@"patientId == %@", self.myPatient.patientId];
    
    [medFetchRequest setPredicate:medPredicate];
    
    self.medicineList = [self.managedObjectContext executeFetchRequest:medFetchRequest error:nil];
    
    
        
    //////////////// ----------- SET LABELS -------------- \\\\\\\\\\\\\\\\\\\\\\\

    // Personal
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.myPatient.firstName, self.myPatient.middleName, self.myPatient.paternalLastName, self.myPatient.maternalLastName];
    self.addressLine1Label.text = [NSString stringWithFormat:@"%@  %@", self.myPatient.line1, self.myPatient.line2];
    self.addressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@", self.myPatient.city, self.myPatient.state, self.myPatient.zip];
    self.phoneNumberLabel.text = self.myPatient.phoneNumber;
    self.emailLabel.text = self.myPatient.email;
    self.dateOfBirthLabel.text = self.myPatient.dateOfBirth;
    self.socialSecurityLabel.text = self.myPatient.socialSecurityNumber;
    
    // Employer
    self.employerNameLabel.text = self.myPatient.empName;
    self.employerAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@", self.myPatient.empLine1, self.myPatient.empLine2];
    self.employerAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@", self.myPatient.empCity, self.myPatient.empState, self.myPatient.empZip];
    self.employerPhoneNumberLabel.text = self.myPatient.empPhoneNumber;
    self.employerEmailLabel.text = self.myPatient.empEmail;
    
    // Emergency Contact
    self.emergencyCNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.myPatient.emeFirstName, self.myPatient.emeMiddleName, self.myPatient.emePaternalLastName, self.myPatient.emeMaternalLastName];
    self.emergencyCAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@", self.myPatient.emeLine1, self.myPatient.emeLine2];
    self.emergencyCAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@", self.myPatient.emeCity, self.myPatient.emeState, self.myPatient.emeZip];
    self.emergencyCPhoneNumberLabel.text = self.myPatient.emePhoneNumber;
    self.emergencyCEmailLabel.text = self.myPatient.emeEmail;

    // Insurance Info
    self.primaryInsuranceNameLabel.text = self.myPatient.insuranceName;
    self.primaryInsurancePolicyNumLabel.text = self.myPatient.policyNumber;
    self.primaryInsuranceGroupNumLabel.text = self.myPatient.groupNumber;
    self.primaryInsuranceRelationshipToPrimaryLabel.text = self.myPatient.relationshipToPrimaryInsured;
    
    self.secondaryInsuranceNameLabel.text = self.myPatient.sInsuranceName;
    self.secondaryInsurancePolicyNumLabel.text = self.myPatient.sPolicyNumber;
    self.secondaryInsuranceGroupNumLabel.text = self.myPatient.sGroupNumber;
    self.secondaryInsuranceRelationshipToPrimaryLabel.text = self.myPatient.srelationshipToPrimaryInsured;
    
     */
    
    NSLog(@"myPatientJSON: %@", self.myPatientJSON);
    
    //////////////// ----------- SET LABELS -------------- \\\\\\\\\\\\\\\\\\\\\\\
    
//    // Personal
//    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
//                               [self verifyForNull:[self.myPatientJSON objectForKey:@"firstName"]],
//                               [self verifyForNull:[self.myPatientJSON objectForKey:@"middleName"]],
//                               [self verifyForNull:[self.myPatientJSON objectForKey:@"paternalLastName"]],
//                               [self verifyForNull:[self.myPatientJSON objectForKey:@"maternalLastName"]]];
//    self.addressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
//                                   [self verifyForNull:[self.myPatientJSON objectForKey:@"addressLine1"]],
//                                   [self verifyForNull:[self.myPatientJSON objectForKey:@"addressLine2"]]];
//    self.addressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
//                                   [self verifyForNull:[self.myPatientJSON objectForKey:@"addressCity"]],
//                                   [self verifyForNull:[self.myPatientJSON objectForKey:@"addressState"]],
//                                   [self verifyForNull:[self.myPatientJSON objectForKey:@"addressZip"]]];
//    self.phoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"phoneNumber"]];
//    self.emailLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"email"]];
//    self.dateOfBirthLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"dateOfBirth"]];
//    self.socialSecurityLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"socialSecurityNumber"]];
//    
//    // Employer
//    self.employerNameLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"employerName"]];
//    self.employerAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
//                                           [self verifyForNull:[self.myPatientJSON objectForKey:@"employerAddressLine1"]],
//                                           [self verifyForNull:[self.myPatientJSON objectForKey:@"employerAddressLine2"]]];
//    self.employerAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
//                                           [self verifyForNull:[self.myPatientJSON objectForKey:@"employerAddressCity"]],
//                                           [self verifyForNull:[self.myPatientJSON objectForKey:@"employerAddressState"]],
//                                           [self verifyForNull:[self.myPatientJSON objectForKey:@"employerAddressZip"]]];
//    self.employerPhoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"employerPhoneNumber"]];
//    self.employerEmailLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"employerEmail"]];
//    
//    // Emergency Contact
//    self.emergencyCNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
//                                     [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactFirstName"]],
//                                     [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactMiddleName"]],
//                                     [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactPaternalLastName"]],
//                                     [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactMaternalLastName"]]];
//    self.emergencyCAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
//                                             [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactAddressLine1"]],
//                                             [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactAddressLine2"]]];
//    self.emergencyCAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
//                                             [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactAddressCity"]],
//                                             [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactAddressState"]],
//                                             [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactAddressZip"]]];
//    self.emergencyCPhoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactPhoneNumber"]];
//    self.emergencyCEmailLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"emergencyContactEmail"]];
//    
//    
//    // Insurance Info
//    self.primaryInsuranceNameLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"primaryInsuranceName"]];
//    self.primaryInsurancePolicyNumLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"primaryInsurancePolicyNumber"]];
//    self.primaryInsuranceGroupNumLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"primaryInsuranceGroupNumber"]];
//    self.primaryInsuranceRelationshipToPrimaryLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"primaryInsuranceRelationshipToPrimaryInsured"]];
//    
//    self.secondaryInsuranceNameLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"secondaryInsuranceName"]];
//    self.secondaryInsurancePolicyNumLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"secondaryInsurancePolicyNumber"]];
//    self.secondaryInsuranceGroupNumLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"secondaryInsuranceGroupNumber"]];
//    self.secondaryInsuranceRelationshipToPrimaryLabel.text = [self verifyForNull:[self.myPatientJSON objectForKey:@"secondaryInsuranceRelationshipToPrimaryInsured"]];
//    

    
    // Get conditions
    [self fetchConditionsForPatientId:[[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
    
    //////////////// ----------- SET LABELS -------------- \\\\\\\\\\\\\\\\\\\\\\\
    
    // Personal
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                               [self verifyForNull:[self.myPatientJSON valueForKey:@"firstName"]],
                               [self verifyForNull:[self.myPatientJSON valueForKey:@"middleName"]],
                               [self verifyForNull:[self.myPatientJSON valueForKey:@"paternalLastName"]],
                               [self verifyForNull:[self.myPatientJSON valueForKey:@"maternalLastName"]]];
    self.addressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
                                   [self verifyForNull:[self.myPatientJSON valueForKey:@"addressLine1"]],
                                   [self verifyForNull:[self.myPatientJSON valueForKey:@"addressLine2"]]];
    self.addressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
                                   [self verifyForNull:[self.myPatientJSON valueForKey:@"addressCity"]],
                                   [self verifyForNull:[self.myPatientJSON valueForKey:@"addressState"]],
                                   [self verifyForNull:[self.myPatientJSON valueForKey:@"addressZip"]]];
    self.phoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"phoneNumber"]];
    self.emailLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"email"]];
    self.dateOfBirthLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"dateOfBirth"]];
    self.socialSecurityLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"socialSecurityNumber"]];
    
    // Employer
    self.employerNameLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerName"]];
    self.employerAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
                                           [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressLine1"]],
                                           [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressLine2"]]];
    self.employerAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
                                           [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressCity"]],
                                           [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressState"]],
                                           [self verifyForNull:[self.myPatientJSON valueForKey:@"employerAddressZip"]]];
    self.employerPhoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerPhoneNumber"]];
    self.employerEmailLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"employerEmail"]];
    
    // Emergency Contact
    self.emergencyCNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                     [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactFirstName"]],
                                     [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactMiddleName"]],
                                     [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactPaternalLastName"]],
                                     [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactMaternalLastName"]]];
    self.emergencyCAddressLine1Label.text = [NSString stringWithFormat:@"%@  %@",
                                             [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressLine1"]],
                                             [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressLine2"]]];
    self.emergencyCAddressLine2Label.text = [NSString stringWithFormat:@"%@  %@  %@",
                                             [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressCity"]],
                                             [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressState"]],
                                             [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactAddressZip"]]];
    self.emergencyCPhoneNumberLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactPhoneNumber"]];
    self.emergencyCEmailLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"emergencyContactEmail"]];
    
    
    // Insurance Info
    self.primaryInsuranceNameLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceName"]];
    self.primaryInsurancePolicyNumLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsurancePolicyNumber"]];
    self.primaryInsuranceGroupNumLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceGroupNumber"]];
    self.primaryInsuranceRelationshipToPrimaryLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"primaryInsuranceRelationshipToPrimaryInsured"]];
    
    self.secondaryInsuranceNameLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceName"]];
    self.secondaryInsurancePolicyNumLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsurancePolicyNumber"]];
    self.secondaryInsuranceGroupNumLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceGroupNumber"]];
    self.secondaryInsuranceRelationshipToPrimaryLabel.text = [self verifyForNull:[self.myPatientJSON valueForKey:@"secondaryInsuranceRelationshipToPrimaryInsured"]];
    

    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchConditionsForPatientId:(NSInteger)pid
{
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSError *error, *e = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest *conditionsGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%i/conditions/?key=%@", pid, key]]];
    
    NSData *conditionsGetData = [NSURLConnection sendSynchronousRequest:conditionsGetRequest returningResponse:&response error:&e];
    
    NSLog(@"Response for conditions get is: %i", [response statusCode]);
    
    if (!conditionsGetData) {
        NSLog(@"conditionsGetData is nil");
        NSLog(@"Error: %@", e);
    }
    
    //Creates the array of dictionary objects, ordered alphabetically
    // Each element in this array is a condition object, whose properties can be accessed as a dictionary
    self.conditionList = [NSJSONSerialization JSONObjectWithData:conditionsGetData options:0 error:&error];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return 12;
            break;
        case 1:
            return 8;
            break;
        case 2:
            return 8;
            break;
        case 3:
            return 6;
            break;
        case 4:
            return self.conditionList.count;
            break;
        case 5:
            return self.medicineList.count;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 4) {
        
        static NSString *CellIdentifier = @"infoConditionCell";
        
        PatientInfoConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //This seems to be important!
        if (cell == nil){
            cell = [[PatientInfoConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *cond = [self.conditionList objectAtIndex:[indexPath row]];
        
        cell.conditionNameLabel.text = [cond valueForKey:@"condition"];
        
        return cell;
    }
    else if ([indexPath section] == 5)
    {
        static NSString *CellIdentifier = @"infoMedicationCell";
        
        //NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:5];
        
        //PatientInfoMedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        PatientInfoMedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //PatientInfoMedicineCell *oCell = (PatientInfoMedicineCell *)[super tableView:tableView cellForRowAtIndexPath:iPath];
        
//        PatientInfoMedicineCell *oCell = self.medicineCell;
//        
//        NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject:oCell];
//        PatientInfoMedicineCell *cell = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
        
        //This seems to be important!
        if (cell == nil){
            cell = [[PatientInfoMedicineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //cell = (PatientInfoMedicineCell *)[super tableView:tableView cellForRowAtIndexPath:iPath];
            //cell = [[PatientInfoMedicineCell alloc] init];
        }
        
        Medicine *med = (Medicine *)[self.medicineList objectAtIndex:[indexPath row]];
        cell.medicineNameLabel.text = med.name;
        cell.dosageLabel.text = med.dosage;
        cell.frequencyLabel.text = med.frequency;
        cell.purposeLabel.text = med.purpose;
        
        
        // Getting the prescriber
        
//        // NSFetchRequest
//        NSFetchRequest *visitFR = [[NSFetchRequest alloc] init];
//        // fetchRequest needs to know what entity to fetch
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
//        [visitFR setEntity:entity];
//        NSPredicate *visitPred;
//        
//        // Set predicate so it searches for our particular patient's visits.
//        visitPred =[NSPredicate predicateWithFormat:@"visitId == %@", med.visitId];
//        [visitFR setPredicate:visitPred];
//        NSArray *singleVisitArray = [self.managedObjectContext executeFetchRequest:visitFR error:nil];
//        
//        Visit *medVisit = [singleVisitArray objectAtIndex:0];
//        
//        NSFetchRequest *prescriberFR = [[NSFetchRequest alloc] init];
//        // fetchRequest needs to know what entity to fetch
//        entity = [NSEntityDescription entityForName:@"Prescriber" inManagedObjectContext:self.managedObjectContext];
//        [prescriberFR setEntity:entity];
//        NSPredicate *prescriberPred;
//        
//        // Set predicate so it searches for our particular patient's visits.
//        prescriberPred =[NSPredicate predicateWithFormat:@"doctorId == %@", medVisit.doctorId];
//        [prescriberFR setPredicate:prescriberPred];
//        NSArray *singlePrescriberArray = [self.managedObjectContext executeFetchRequest:prescriberFR error:nil];
//
//        NSLog(@"The doctorId for this visit is: %@", medVisit.doctorId);
//        
//        Prescriber *thisMedsPrescriber = nil;
//        
//        // Must remove this if-else later
//        if (singlePrescriberArray.count > 0)
//        {
//            thisMedsPrescriber = [singlePrescriberArray objectAtIndex:0];
//        }
//        else
//        {
//            NSLog(@"Patient med has no prescriber");
////            thisMedsPrescriber = [[Prescriber alloc] init];
////            thisMedsPrescriber.fullName = [NSString stringWithString:@"I do not exist."];
////            thisMedsPrescriber.addressLine1 = @"This address does not exist.";
////            thisMedsPrescriber.addressLine2 = @" ";
////            thisMedsPrescriber.phoneNumber = @"Phone does not exist.";
////            thisMedsPrescriber.email = @"This email does not exist";
//        }
//        
//        // Setting the cell with the prescriber
//        cell.prescriber = thisMedsPrescriber;
//        //cell.prescriber = self.myDoctor;
        
        cell.myVC = self;
        //[self.medicineCells addObject:cell];
         
        NSLog(@"Med name is: %@, label is %@", med.name, cell.medicineNameLabel.text);
        NSLog(@"Cell is: %@  and is kindOfClass: %@", cell, [cell class]);
        NSLog(@"Number of meds: %d", self.medicineList.count);
        
        return cell;
    }
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    // Configure the cell...
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 4 || [indexPath section] == 5)
    {
        //return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[indexPath section]]];
        return 44;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 4 || [indexPath section] == 5) {
        return YES;
    }
    else
    {
        // Return NO if you do not want the specified item to be editable.
        return NO;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (section == 4 || section == 5) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
