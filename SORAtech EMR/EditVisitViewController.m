//
//  EditVisitViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditVisitViewController.h"
#import "ExistingVisitViewController.h"
#import "KeychainItemWrapper.h"

@interface EditVisitViewController ()

@property (strong, nonatomic) NSDictionary *editedVisit;

@end

@implementation EditVisitViewController

@synthesize editVisit, editedVisit, myPatientJSON, patientNameLabel, dateField, systolicBPField, diastolicBPField, pulseField, temperatureField, heightField, weightField, visitNotes;

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
    
    self.dateField.text = [self.editVisit valueForKey:@"date"];
    self.systolicBPField.text = [self.editVisit valueForKey:@"systolicBloodPressure"];
    self.diastolicBPField.text = [self.editVisit valueForKey:@"diastolicBloodPressure"];
    self.pulseField.text = [self.editVisit valueForKey:@"pulse"];
    self.temperatureField.text = [self.editVisit valueForKey:@"temperature"];
    self.heightField.text = [self.editVisit valueForKey:@"height"];
    self.weightField.text = [self.editVisit valueForKey:@"weight"];
    self.visitNotes.text = [self.editVisit valueForKey:@"notes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Save the edited visit to the db
- (IBAction)doneEditingVisit:(id)sender
{
    // First we send the request to edit the patient to the db and get the edited patient's info back
    [self prepareVisitEdit];
    
    NSArray *vcs = [self.navigationController viewControllers];
    NSInteger numVCs = vcs.count;
    ExistingVisitViewController *evVC = [vcs objectAtIndex:numVCs - 2];
    evVC.myPatientJSON = self.myPatientJSON;
    evVC.myVisitJSON = self.editedVisit;
    
    // Pop to previous vc:
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareVisitEdit
{
    NSDictionary *visitEdited = [[NSDictionary alloc] initWithObjectsAndKeys:
                   self.dateField.text, @"date",
                   self.systolicBPField.text, @"systolicBloodPressure",
                   self.diastolicBPField.text, @"diastolicBloodPressure",
                   self.pulseField.text, @"pulse",
                   self.temperatureField.text, @"temperature",
                   self.heightField.text, @"height",
                   self.weightField.text, @"weight",
                   self.visitNotes.text, @"notes",
                   nil];
    
    //Insert a edited visit in the db
    NSError *error = nil;
    
    NSData *editedVisitJSONData = [NSJSONSerialization dataWithJSONObject:visitEdited options:NSJSONWritingPrettyPrinted error:&error];
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    // Send the new patient in json to server
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/visits/%@/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], [self.editVisit valueForKey:@"visitId"], key]];
    
    NSLog(@"Visit edit url: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", editedVisitJSONData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:editedVisitJSONData];
    
    // Response
    //NSURLResponse *response = nil;
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    
    NSLog(@"Response satus code: %i", [response statusCode]);
    
    [self getEditedVisitFromDB];
}

- (void)getEditedVisitFromDB
{
    /////////////////////////////////////////////////////////////////////////////////////////////
    // GET THE EDITED VISIT FROM THE DB, TO MAKE SURE WE HAVE UPDATED THE INFO IN THE DB
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSError *getError = nil;
    //NSURLResponse *response = nil;
    NSHTTPURLResponse *getResponse = nil;
    
    // Get the JSON for the specific edited visit from the db
    NSURLRequest *visitGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%@/visits/%@/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], [self.editVisit valueForKey:@"visitId"], key]]];
    
    NSData *visitGetData = [NSURLConnection sendSynchronousRequest:visitGetRequest returningResponse:&getResponse error:&getError];
    
    NSLog(@"Response for edited visit get is: %i", [getResponse statusCode]);
    
    if (!visitGetData) {
        NSLog(@"visitGetData is nil");
        NSLog(@"Error: %@", getError);
    }
    
    // Should have only one element in the json array, which is the edited patient's dictionary
    NSArray *editedArr = [NSJSONSerialization JSONObjectWithData:visitGetData options:0 error:&getError];
    
    self.editedVisit = [editedArr objectAtIndex:0];
    
    NSLog(@"Edited Visit!");
}

@end
