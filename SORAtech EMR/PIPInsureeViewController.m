//
//  PIPInsureeViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/30/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PIPInsureeViewController.h"

@interface PIPInsureeViewController ()

@end

@implementation PIPInsureeViewController

@synthesize myPatient;
@synthesize pipFullName, pipAddressLine1, pipAddressLine2, pipPhoneNum, pipDateOfBirth, pipEmail, pipSocialSecurityNum;

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
    
    self.pipFullName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.myPatient.piFirstName, self.myPatient.piMiddleName, self.myPatient.piPaternalLastName, self.myPatient.piMaternalLastName];
    self.pipAddressLine1.text = [NSString stringWithFormat:@"%@ %@", self.myPatient.piLine1, self.myPatient.piLine2];
    self.pipAddressLine2.text = [NSString stringWithFormat:@"%@ %@ %@", self.myPatient.piCity, self.myPatient.piState, self.myPatient.piZip];
    self.pipPhoneNum.text = self.myPatient.piPhoneNumber;
    self.pipDateOfBirth.text = self.myPatient.piDateOfBirth;
    self.pipEmail.text = self.myPatient.piEmail;
    self.pipSocialSecurityNum.text = self.myPatient.piSocialSecurityNumber;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
