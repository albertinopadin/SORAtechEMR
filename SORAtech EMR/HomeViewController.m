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
    if ([segue.identifier isEqualToString:@"toDoctorFillInfoSegue"])
    {
        DoctorInfoInputViewController *divc = [segue destinationViewController];
        divc.myDoctor = self.myDoctor;
    }
    else if ([segue.identifier isEqualToString:@"toSearchPatientSegue"])
    {
        PatientSearchViewController *psvc = [segue destinationViewController];
        psvc.myDoctor = self.myDoctor;
        
        NSLog(@"Home: Doctor's name is: %@", self.myDoctor.fullName);
    }
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}
@end
