//
//  PatientInfoTableViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/20/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientInfoTableViewController.h"
#import "STAppDelegate.h"
#import "Condition.h"
#import "Medicine.h"
#import "PrescriberViewController.h"

@interface PatientInfoTableViewController ()

@property (strong, nonatomic) Prescriber *currentDesignatedPrescriber;

@end

@implementation PatientInfoTableViewController

@synthesize currentDesignatedPrescriber;

@synthesize myTableView, medicineCells;

@synthesize myPatient, myDoctor, visitList, medicineList, conditionList;

@synthesize fullNameLabel, addressLine1Label, addressLine2Label, phoneNumberLabel, emailLabel, dateOfBirthLabel, socialSecurityLabel;

@synthesize employerNameLabel, employerAddressLine1Label, employerAddressLine2Label, employerPhoneNumberLabel, employerEmailLabel;

@synthesize emergencyCNameLabel, emergencyCAddressLine1Label, emergencyCAddressLine2Label, emergencyCPhoneNumberLabel, emergencyCEmailLabel;

@synthesize primaryInsuranceNameLabel, primaryInsurancePolicyNumLabel, primaryInsuranceRelationshipToPrimaryLabel;

@synthesize secondaryInsuranceNameLabel, secondaryInsurancePolicyNumLabel, secondaryInsuranceRelationshipToPrimaryLabel;


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

- (void)goToPrescriberViewWithPrescriber:(Prescriber *)thePrescriber
{
    self.currentDesignatedPrescriber = thePrescriber;
    [self performSegueWithIdentifier:@"toPrescriberSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPrescriberSegue"])
    {
        PrescriberViewController *pvc = segue.destinationViewController;
        pvc.myPrescriber = self.currentDesignatedPrescriber;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
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
    
    // This for gets all the medicines that have been prescribed to the patient on their visits.
    for (int i = 0; i < [self.visitList count]; i++)
    {
        // Set predicate so it searches for the medicines associated with the patient's visits.
        medPredicate =[NSPredicate predicateWithFormat:@"visitId == %@", [[self.visitList objectAtIndex:i] visitId]];
        
        [medFetchRequest setPredicate:medPredicate];
        
        NSArray *visitMeds = [self.managedObjectContext executeFetchRequest:medFetchRequest error:nil];
        
        self.medicineList = [self.medicineList arrayByAddingObjectsFromArray:visitMeds];
    }
    
    // Registering the Classes with the table view
    //[self.tableView registerClass:[PatientInfoConditionCell class] forCellReuseIdentifier:@"infoConditionCell"];
    //[self.myTableView registerClass:[PatientInfoMedicineCell class] forCellReuseIdentifier:@"infoMedicationCell"];
    
    //////////////// ----------- SET LABELS -------------- \\\\\\\\\\\\\\\\\\\\\\\

    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.myPatient.firstName, self.myPatient.middleName, self.myPatient.paternalLastName, self.myPatient.maternalLastName];
    self.addressLine1Label.text = self.myPatient.line1;
    self.addressLine2Label.text = self.myPatient.line2;
    self.phoneNumberLabel.text = self.myPatient.phoneNumber;
    self.emailLabel.text = self.myPatient.email;
    self.dateOfBirthLabel.text = self.myPatient.dateOfBirth;
    self.socialSecurityLabel.text = self.myPatient.socialSecurityNumber;
    
    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        
        Condition *cond = (Condition *)[self.conditionList objectAtIndex:[indexPath row]];
        
        //cell.textLabel.text = cond.conditionName;
        cell.conditionNameLabel.text = cond.conditionName;
        
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
        
        // NSFetchRequest
        NSFetchRequest *visitFR = [[NSFetchRequest alloc] init];
        // fetchRequest needs to know what entity to fetch
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
        [visitFR setEntity:entity];
        NSPredicate *visitPred;
        
        // Set predicate so it searches for our particular patient's visits.
        visitPred =[NSPredicate predicateWithFormat:@"visitId == %@", med.visitId];
        [visitFR setPredicate:visitPred];
        NSArray *singleVisitArray = [self.managedObjectContext executeFetchRequest:visitFR error:nil];
        
        Visit *medVisit = [singleVisitArray objectAtIndex:0];
        
        NSFetchRequest *prescriberFR = [[NSFetchRequest alloc] init];
        // fetchRequest needs to know what entity to fetch
        entity = [NSEntityDescription entityForName:@"Prescriber" inManagedObjectContext:self.managedObjectContext];
        [prescriberFR setEntity:entity];
        NSPredicate *prescriberPred;
        
        // Set predicate so it searches for our particular patient's visits.
        prescriberPred =[NSPredicate predicateWithFormat:@"doctorId == %@", medVisit.doctorId];
        [prescriberFR setPredicate:prescriberPred];
        NSArray *singlePrescriberArray = [self.managedObjectContext executeFetchRequest:prescriberFR error:nil];

        NSLog(@"The doctorId for this visit is: %@", medVisit.doctorId);
        
        Prescriber *thisMedsPrescriber = nil;
        
        // Must remove this if-else later
        if (singlePrescriberArray.count > 0)
        {
            thisMedsPrescriber = [singlePrescriberArray objectAtIndex:0];
        }
        else
        {
            NSLog(@"Patient med has no prescriber");
//            thisMedsPrescriber = [[Prescriber alloc] init];
//            thisMedsPrescriber.fullName = [NSString stringWithString:@"I do not exist."];
//            thisMedsPrescriber.addressLine1 = @"This address does not exist.";
//            thisMedsPrescriber.addressLine2 = @" ";
//            thisMedsPrescriber.phoneNumber = @"Phone does not exist.";
//            thisMedsPrescriber.email = @"This email does not exist";
        }
        
        // Setting the cell with the prescriber
        cell.prescriber = thisMedsPrescriber;
        //cell.prescriber = self.myDoctor;
        
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
