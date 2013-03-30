//
//  SIPInsureeViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/30/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "SIPInsureeViewController.h"

@interface SIPInsureeViewController ()

@end

@implementation SIPInsureeViewController

@synthesize myPatient;
@synthesize sipFullName, sipAddressLine1, sipAddressLine2, sipPhoneNum, sipEmail, sipDateOfBirth, sipSocialSecurityNum;

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
    
    self.sipFullName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.myPatient.sPiFirstName, self.myPatient.sPiMiddleName, self.myPatient.sPiPaternalLastName, self.myPatient.sPiMaternalLastName];
    self.sipAddressLine1.text = [NSString stringWithFormat:@"%@ %@", self.myPatient.sPiLine1, self.myPatient.sPiLine2];
    self.sipAddressLine2.text = [NSString stringWithFormat:@"%@ %@ %@", self.myPatient.sPiCity, self.myPatient.sPiState, self.myPatient.sPiZip];
    self.sipPhoneNum.text = self.myPatient.sPiPhoneNumber;
    self.sipDateOfBirth.text = self.myPatient.sPiDateOfBirth;
    self.sipEmail.text = self.myPatient.sPiEmail;
    self.sipSocialSecurityNum.text = self.myPatient.sPiSocialSecurityNumber;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
