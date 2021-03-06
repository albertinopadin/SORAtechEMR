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

@synthesize patient, textFields;

//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (BOOL)textFieldEmpty
{
    textFields = [NSArray arrayWithObjects:firstName, middleName, paternalLastName, maternalLastName, socialSecurity, addressLine1, addressLine2, state, city, zipCode, dateOfBirth, phoneNumber, email, nil];
    
    BOOL isEmpty = NO;
    
    for (UITextField *tf in textFields)
    {
        if ([tf.text length] == 0)
        {
            isEmpty = YES;
        }
    }
    
    return isEmpty;
}

- (BOOL)namesPresent
{
    BOOL namesPresent = YES;
    
    if ([self.firstName.text length] == 0 || [self.paternalLastName.text length] == 0 || [self.maternalLastName.text length] == 0)
    {
        namesPresent = NO;
    }
    
    return namesPresent;
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

@end
