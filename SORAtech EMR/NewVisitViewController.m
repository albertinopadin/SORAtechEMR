//
//  NewVisitViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NewVisitViewController.h"
#import "STAppDelegate.h"
#import "HomeViewController.h"
#import "KeychainItemWrapper.h"

@interface NewVisitViewController ()

@end

@implementation NewVisitViewController

@synthesize myPatientJSON, nVisit, visitList, patientNameLabel, dateField, systolicBPField, diastolicBPField, pulseField, temperatureField, heightField, weightField, visitNotes;

@synthesize conditionsArray, medicationsArray, conditionsTableVC, medicationsTableVC;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  [self.myPatientJSON valueForKey:@"firstName"],
                                  [self.myPatientJSON valueForKey:@"middleName"],
                                  [self.myPatientJSON valueForKey:@"paternalLastName"],
                                  [self.myPatientJSON valueForKey:@"maternalLastName"]];

    
    // Initialize table vc's
//    self.medicationsTableVC = [[MedicationsTableViewController alloc] init];
//    self.conditionsTableVC = [[ConditionsTableViewController alloc] init];
//    
//    // Set up the table vc's with their respective table views
//    self.medicationsTableVC.tableView = self.medicationsTable;
//    self.medicationsTable.dataSource = self.medicationsTableVC;
//    self.medicationsTable.delegate = self.medicationsTableVC;
//    
//    self.conditionsTableVC.tableView = self.conditionsTable;
//    self.conditionsTable.dataSource = self.conditionsTableVC;
//    self.conditionsTable.delegate = self.conditionsTableVC;
    
    
    // Get the current date and prepopulate the date field
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@", currentDate];
    NSArray *arr = [dateString componentsSeparatedByString:@" "];
    NSString *date = [arr objectAtIndex:0];
    NSArray *dateComponents = [date componentsSeparatedByString:@"-"];
    
    NSInteger month = [[dateComponents objectAtIndex:1] intValue];
    NSInteger day = [[dateComponents objectAtIndex:2] intValue];
    NSInteger year = [[dateComponents objectAtIndex:0] intValue];
    
    self.dateField.text = [NSString stringWithFormat:@" %d / %d / %d", month, day, year];
    
    //Create fetch request for the Patient entity table
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Visit"];
    
    //Execute the fetch request through the managed object context to get the patient list
    //self.visitList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    // Set textview delegate so when user taps on it the text clears only the first time:
    self.visitNotes.delegate = self;
}

// TextView delegate method
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.visitNotes.text isEqualToString:@"Enter your notes here."])
    {
        self.visitNotes.text = @"";
    }
}

// We don't use button methods, we just do this before whatever segue is triggered
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Gather data in newVisit dictionary
    self.nVisit = [[NSDictionary alloc] initWithObjectsAndKeys:
                     self.dateField.text, @"date",
                     self.systolicBPField.text, @"systolicBloodPressure",
                     self.diastolicBPField.text, @"diastolicBloodPressure",
                     self.pulseField.text, @"pulse",
                     self.temperatureField.text, @"temperature",
                     self.heightField.text, @"height",
                     self.weightField.text, @"weight",
                     self.visitNotes.text, @"notes",
                     nil];
    
    //Insert a new visit in the db
    
    NSError *error = nil;
    
    NSData *newVisitJSONData = [NSJSONSerialization dataWithJSONObject:nVisit options:NSJSONWritingPrettyPrinted error:&error];
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    //NSLog(@"Adding new patient; user's key is: %@", key);
    // Send the new patient in json to server
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/visits/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], key]];
    
    NSLog(@"Visit insert url: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", newVisitJSONData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:newVisitJSONData];
    
    // Response
    //NSURLResponse *response = nil;
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];

    NSLog(@"Response satus code: %i", [response statusCode]);
    
    
    
    
    /*
    //Insert a new visit in the visit table
    self.visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
    
    //Get the visit information
    self.visit.date = self.dateField.text;
    self.visit.systolicBloodPressure = self.systolicBPField.text;
    self.visit.diastolicBloodPressure = self.diastolicBPField.text;
    self.visit.pulse = self.pulseField.text;
    self.visit.temperature = self.temperatureField.text;
    self.visit.weight = self.weightField.text;
    self.visit.height = self.heightField.text;
    self.visit.notes = self.visitNotes.text;
    
    self.visit.patientId = self.myPatient.patientId;
    self.visit.visitId = [NSNumber numberWithInt:self.visitList.count + 1];
    
    self.visit.doctorId = self.myDoctor.doctorId;
    
    NSLog(@"DoctorId is: %@", self.myDoctor.doctorId);
    
    //Save the information using the context
    NSError *saveError = nil;
    
    [self.managedObjectContext save:&saveError];
    */
//    for (ConditionCell *condCell in self.conditionsTableVC.conditionCellSet)
//    //for (ConditionCell *condCell in self.conditionsTableVC.conditionCellArray)
//    //for (UITextField *condCellTF in self.conditionsTableVC.conditionTextBoxArray)
//    {
//        // If text field in cell is empty DO NOT INSERT
//        if ([condCell.condition.text length] == 0)
//        {
//            //Do nothing, we don't want to insert empty condition
//        }
//        else
//        {
//            //Insert a new condition in the condition table
//            Condition *cond = [NSEntityDescription insertNewObjectForEntityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
//            cond.patientId = self.myPatient.patientId;
//            cond.visitId = self.visit.visitId;
//            cond.conditionName = condCell.myCondition;
//            [self.managedObjectContext save:&saveError];
//            
//            // TESTING
//            if (condCell == nil) {
//                NSLog(@"The cond cell is nil");
//            }
//            if (condCell.condition == nil) {
//                NSLog(@"The condition textbox is nil");
//            }
//            if (condCell.condition.text == nil) {
//                NSLog(@"The text in the cond cell is nil");
//            }
//            if (condCell.myCondition == nil) {
//                NSLog(@"condCell.myCondition is nil");
//            }
//            else{
//                NSLog(@"%@", condCell.myCondition);
//            }
//
//        }
//                
//    }
//
//    for (MedicationCell *medCell in self.medicationsTableVC.medicationCellArray)
//    {
//        // If text field in cell is empty DO NOT INSERT
//        if ([medCell.medication.text length] == 0)
//        {
//            //Do nothing, we don't want to insert empty medication
//        }
//        else
//        {
//            //Insert a new medication in the medicine table
//            Medicine *med = [NSEntityDescription insertNewObjectForEntityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
//            med.visitId = self.visit.visitId;
//            med.patientId = self.myPatient.patientId;
//            med.firstName = self.myPatient.firstName;
//            med.middleName = self.myPatient.middleName;
//            med.paternalLastName = self.myPatient.paternalLastName;
//            med.maternalLastName = self.myPatient.maternalLastName;
//            med.city = self.myPatient.city;
//            med.state = self.myPatient.state;
//            med.zip = self.myPatient.zip;
//            
//            med.name = medCell.medication.text;
//            med.dosage = medCell.dose.text;
//            med.frequency = medCell.frequency.text;
//            med.purpose = medCell.purpose.text;
//            
//            [self.managedObjectContext save:&saveError];
//        }
//        
//    }

    
    UINavigationController *nav = [segue destinationViewController];
    HomeViewController *hvc = [[nav viewControllers] objectAtIndex:0];
    [hvc incomingSegue:@"fromNewVisitPage"];
    
    NSLog(@"Added a new Visit!");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)addConditionButtonPressed:(id)sender
//{
//    [self.conditionsTableVC addNewConditionCell];
//}
//
//- (IBAction)addMedicationButtonPressed:(id)sender
//{
//    NSLog(@"In addMedicationButtonPressed method");
//    
//    [self.medicationsTableVC addNewMedicationCell];
//}
@end
