//
//  NewPatientViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientPersonalInfoViewController.h"
#import "STAppDelegate.h"

@interface PatientPersonalInfoViewController ()

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *patientList;

@end

@implementation PatientPersonalInfoViewController

//Synthesize text fields
@synthesize firstName, middleName, paternalLastName, maternalLastName, socialSecurity, addressLine1, addressLine2, state, city, zipCode, dateOfBirth, phoneNumber, email;

@synthesize patient;

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
    
    //Create fetch request for the Patient entity table
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
    
    //Execute the fetch request through the managed object context to get the patient list
    //self.patientList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)okPressed:(id)sender
//{
//    //Insert a new patient in the patient table
//    patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
//    
//    //Get the patient information
//    patient.firstName = self.firstName.text;
//    patient.middleName = self.middleName.text;
//    patient.paternalLastName = self.paternalLastName.text;
//    patient.maternalLastName = self.maternalLastName.text;
//    patient.socialSecurityNumber = self.socialSecurity.text;
//    patient.line1 = self.addressLine1.text;
//    patient.line2 = self.addressLine2.text;
//    patient.state = self.state.text;
//    patient.city = self.city.text;
//    patient.zip = self.zipCode.text;
//    
//    patient.dateOfBirth = self.dateOfBirth.text;
//    patient.phoneNumber = self.phoneNumber.text;
//    patient.email = self.email.text;
//    
//    patient.patientId = [NSNumber numberWithInt:self.patientList.count + 1];
//    
//    //Save the information using the context
//    NSError *saveError = nil;
//    
//    [self.managedObjectContext save:&saveError];
//    
//    NSLog(@"Added a new Patient!");
//
//}


@end
