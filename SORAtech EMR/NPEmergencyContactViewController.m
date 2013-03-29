//
//  NPEmergencyContactViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPEmergencyContactViewController.h"

@interface NPEmergencyContactViewController ()

@end

@implementation NPEmergencyContactViewController

@synthesize emergencyCFirstName, emergencyCMiddleName, emergencyCPaternalLastName, emergencyCMaternalLastName, emergencyCAddressLine1, emergencyCAddressLine2, emergencyCPhoneNumber, emergencyCEmail;

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

@end
