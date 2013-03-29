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


@interface NewPatientTBViewController ()

@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) NSArray *vcArray;
@property (strong, nonatomic) NSArray *patientList;

@end

@implementation NewPatientTBViewController

@synthesize patient, vcArray, patientList;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get patient list
    //Create fetch request for the Patient entity table
    NSFetchRequest *patientListFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
    
    //Execute the fetch request through the managed object context to get the patient list
    self.patientList = [self.managedObjectContext executeFetchRequest:patientListFetchRequest error:nil];
    
    //Insert a new patient in the patient table
    patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    
    //Get the patient information
    
    //Get each view controller from my array of vc's
    self.vcArray = [self viewControllers];
    
    PatientPersonalInfoViewController *personalVC = [self.vcArray objectAtIndex:0];
    
    
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
    
    //Save the information using the context
    NSError *saveError = nil;
    
    [self.managedObjectContext save:&saveError];
    
    NSLog(@"Added a new Patient!");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
