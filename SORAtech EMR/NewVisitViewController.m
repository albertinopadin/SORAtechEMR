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
#import "STBluetoothHandler.h"

@interface NewVisitViewController ()

@property (strong, nonatomic) STBluetoothHandler *btHandler;

@end

@implementation NewVisitViewController

@synthesize btHandler, tempGetButton, heightGetButton, weightGetButton;
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

- (void)disableBTButtons
{
    self.tempGetButton.userInteractionEnabled = NO;
    self.heightGetButton.userInteractionEnabled = NO;
    self.weightGetButton.userInteractionEnabled = NO;
    
    self.tempGetButton.alpha = 0.4;
    self.heightGetButton.alpha = 0.4;
    self.weightGetButton.alpha = 0.4;
}

- (void)enableBTButtons
{
    self.tempGetButton.userInteractionEnabled = YES;
    self.heightGetButton.userInteractionEnabled = YES;
    self.weightGetButton.userInteractionEnabled = YES;
    
    self.tempGetButton.alpha = 1.0;
    self.heightGetButton.alpha = 1.0;
    self.weightGetButton.alpha = 1.0;
}

- (IBAction)getTemperatureFromMCU:(id)sender
{

}

- (IBAction)getHeightFromMCU:(id)sender
{
    [self.btHandler startHeightRead];
}

- (IBAction)getWeightFromMCU:(id)sender
{

}

- (void)readHeightFinished
{
    NSLog(@"From new visit vc, btHandler getPatientHeight: %i", [self.btHandler getPatientHeight]);
    self.heightField.text = [NSString stringWithFormat:@"%i", [self.btHandler getPatientHeight]];
}

- (void)readWeightFinished
{
    
}

- (void)readTemperatureFinished
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Disable the buttons that depend on the bluetooth
    [self disableBTButtons];
    
    self.btHandler = [[STBluetoothHandler alloc] init];
    [self.btHandler bluetoothHandlerInit];
    self.btHandler.myNewVisitVC = self;
    
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
    // Network Activity Indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
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

    
    UINavigationController *nav = [segue destinationViewController];
    HomeViewController *hvc = [[nav viewControllers] objectAtIndex:0];
    [hvc incomingSegue:@"fromNewVisitPage"];
    
    NSLog(@"Added a new Visit!");
    
    // Network Activity Indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
