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

@synthesize myPatientJSON;
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
    
    self.sipFullName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredFirstName"],
                             [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMiddleName"],
                             [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPaternalLastName"],
                             [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMaternalLastName"]];
    self.sipAddressLine1.text = [NSString stringWithFormat:@"%@ %@",
                                 [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine1"],
                                 [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine2"]];
    self.sipAddressLine2.text = [NSString stringWithFormat:@"%@ %@ %@",
                                 [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressCity"],
                                 [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressState"],
                                 [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressZip"]];
    self.sipPhoneNum.text = [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPhoneNumber"];
    self.sipDateOfBirth.text = [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredDateOfBirth"];
    self.sipEmail.text = [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredEmail"];
    self.sipSocialSecurityNum.text = [self.myPatientJSON valueForKey:@"secondaryInsurancePrimaryInsuredSocialSecurityNumber"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
