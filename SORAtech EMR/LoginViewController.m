//
//  LoginViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/16/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "LoginViewController.h"
#import "STAppDelegate.h"
#import "Prescriber.h"
#import "HomeViewController.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSString *defaultLoginKey;
@property (nonatomic) NSInteger defaultDoctorId;
@property (strong, nonatomic) Prescriber *myDoctor;

@end

@implementation LoginViewController

@synthesize defaultLoginKey, defaultDoctorId, myDoctor, loginKeyTextField;

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
        // This method is not called, so we do not initialize here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set up text field so it responds to enter key:
    self.loginKeyTextField.delegate = self;
    
    
    //Initialize default login key so user can log in
    defaultLoginKey = @"magic";
    
    //Set default doctorId
    self.defaultDoctorId = 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginButtonPressed:textField];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    // Searching for the doctor in the db
    NSFetchRequest *prescriberFR = [[NSFetchRequest alloc] init];
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Prescriber" inManagedObjectContext:self.managedObjectContext];
    [prescriberFR setEntity:entity];
    NSPredicate *prescriberPred;
    
    // Set predicate so it searches for our particular patient's visits.
    prescriberPred =[NSPredicate predicateWithFormat:@"doctorId == %i", self.defaultDoctorId];
    [prescriberFR setPredicate:prescriberPred];
    NSArray *singlePrescriberArray = [self.managedObjectContext executeFetchRequest:prescriberFR error:nil];
    
    NSLog(@"singlePrescriberArray is: %@", singlePrescriberArray);
    
    //self.myDoctor = nil;
    
    // Must remove this if-else later
    if (singlePrescriberArray.count > 0)
    {
        self.myDoctor = [singlePrescriberArray objectAtIndex:0];
        NSLog(@"Detected existing doctor: %@", self.myDoctor);
    }
    else
    {
        //Insert a new doctor in the prescriber table
        self.myDoctor = [NSEntityDescription insertNewObjectForEntityForName:@"Prescriber" inManagedObjectContext:self.managedObjectContext];
        
        self.myDoctor.doctorId = [NSNumber numberWithInt:self.defaultDoctorId];
        self.myDoctor.fullName = @"Default Full Name";
        self.myDoctor.addressLine1 = @"Default addressLine1";
        self.myDoctor.addressLine2 = @"Default addressLine2";
        self.myDoctor.phoneNumber = @"***-***-****";
        self.myDoctor.email = @"Default email";
        
        //Save the information using the context
        NSError *saveError = nil;
        
        [self.managedObjectContext save:&saveError];
        
        NSLog(@"Added a new Doctor!");
        
    }

    // Now we segue
    if ([defaultLoginKey isEqualToString:loginKeyTextField.text]) {
        
        NSError *error, *e, *e2 = nil;
        NSURLResponse *response = nil;
        
        NSURLRequest *loginRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.services.soratech.cardona150.com/emr/doctors/?key=e8342f8b-c73c-44c9-bd19-327b54c9ed65"]];
        
        NSData *loginData = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&e2];
        
        if (!loginData) {
            NSLog(@"loginData is nil");
            NSLog(@"Error: %@", e);
        }
        
        //Creates the array of dictionary objects, ordered alphabetically
        NSArray *dataFromJSON = [NSJSONSerialization JSONObjectWithData:loginData options:0 error:&error];
        
        if (!dataFromJSON) {
            NSLog(@"Error parsing JSON: %@", error);
        }
        else
        {
            if ([dataFromJSON count] > 0)
            {
                NSLog(@"Succesful Login");
                
                // Storing the key in the keychain for persistent secure storage
                KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
                [keychainStore setObject:@"e8342f8b-c73c-44c9-bd19-327b54c9ed65" forKey:CFBridgingRelease(kSecValueData)];
                
                //Proceed with segue
                [self performSegueWithIdentifier:@"SuccessfulLoginSegue" sender:self];
            }
            else
            {
                UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"There was a problem with the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [loginError show];
            }
        }

    }
    else
    {
        //Display Login Error message
        //NSLog(@"User input incorrect key");
        UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"You have typed an incorrect login key" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginError show];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = [segue destinationViewController];
    HomeViewController *hvc = [[nav viewControllers] objectAtIndex:0];
    hvc.myDoctor = self.myDoctor;
}

@end
