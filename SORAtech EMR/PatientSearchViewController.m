//
//  PatientSearchViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientSearchViewController.h"
#import "SearchResultsViewController.h"

@interface PatientSearchViewController ()

@end

@implementation PatientSearchViewController

@synthesize searchBox;

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
    self.searchBox.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Not sure if this method is needed or if the prepareForSegue is enough
- (IBAction)searchButtonPressed:(id)sender
{
    //[self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"patientNameSearchSegue" sender:self];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"patientNameSearchSegue"])
    {
        SearchResultsViewController *srvc = segue.destinationViewController;
        srvc.searchTerm = searchBox.text;
    }
}


@end
