//
//  HomeViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "HomeViewController.h"
#import "DoctorInfoInputViewController.h"
#import "PatientSearchViewController.h"
#import "SearchResultsViewController.h"
#import "NewPatientTBViewController.h"
#import "KeychainItemWrapper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize myDoctor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)incomingSegue:(NSString *)segueIdentifier
{
    if ([segueIdentifier isEqualToString:@"fromNewVisitPage"] || [segueIdentifier isEqualToString:@"fromNewPatientPage"])
    {
        [self performSegueWithIdentifier:@"toSearchPatientSegue" sender:self];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"toDoctorFillInfoSegue"])
//    {
//        DoctorInfoInputViewController *divc = [segue destinationViewController];
//        divc.myDoctor = self.myDoctor;
//    }
//    if ([segue.identifier isEqualToString:@"toSearchPatientSegue"])
//    {
//        PatientSearchViewController *psvc = [segue destinationViewController];
//        psvc.myDoctor = self.myDoctor;
//        
//        NSLog(@"Home: Doctor's name is: %@", self.myDoctor.fullName);
//    }
    if ([segue.identifier isEqualToString:@"toSearchPatientSegue"])
    {
        SearchResultsViewController *srvc = [segue destinationViewController];
        srvc.myDoctor = self.myDoctor;
        srvc.searchTerm = @"";
        
        NSLog(@"Home: Doctor's name is: %@", self.myDoctor.fullName);
    }
    else if ([segue.identifier isEqualToString:@"newPatientSegue"])
    {
        NewPatientTBViewController *npvc = [segue destinationViewController];
        npvc.myDoctor = self.myDoctor;
    }
}

- (IBAction)logoutButtonPressed:(id)sender
{
    // Resetting the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    [keychainStore resetKeychainItem];
    
    //NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    //NSLog(@"Key at logout is: %@", key);
    
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}
@end
