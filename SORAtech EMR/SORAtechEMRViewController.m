//
//  SORAtechEMRViewController.m
//  SORAtechEMR_mockup_1
//
//  Created by Albertino Padin on 2/19/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "SORAtechEMRViewController.h"

@interface SORAtechEMRViewController ()

@end

@implementation SORAtechEMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(doSegue) withObject:nil afterDelay:2.00];
}

- (void)doSegue
{
    [self performSegueWithIdentifier:@"AfterIntroSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //UINavigationController *navCon = segue.destinationViewController;
    //AddPatientViewController *addPatientVC =
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
