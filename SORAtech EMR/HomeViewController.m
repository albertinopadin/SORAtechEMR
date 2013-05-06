//
//  HomeViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "HomeViewController.h"
#import "PatientSearchViewController.h"
#import "SearchResultsViewController.h"
#import "KeychainItemWrapper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    if ([segue.identifier isEqualToString:@"toSearchPatientSegue"])
    {
        // Network Activity Indicator
        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        SearchResultsViewController *srvc = [segue destinationViewController];
        srvc.searchTerm = @"";
    }
}

- (IBAction)logoutButtonPressed:(id)sender
{
    // Resetting the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    [keychainStore resetKeychainItem];
    
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}
@end
