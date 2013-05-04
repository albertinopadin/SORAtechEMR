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

@synthesize myPatientJSON;
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
    
    NSLog(@"myPatientJSON: %@", self.myPatientJSON);
    
    self.pipFullName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredFirstName"],
                             [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredMiddleName"],
                             [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredPaternalLastName"],
                             [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredMaternalLastName"]];
    self.pipAddressLine1.text = [NSString stringWithFormat:@"%@ %@",
                                 [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine1"],
                                 [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine2"]];
    self.pipAddressLine2.text = [NSString stringWithFormat:@"%@ %@ %@",
                                 [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressCity"],
                                 [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressState"],
                                 [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressZip"]];
    self.pipPhoneNum.text = [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredPhoneNumber"];
    self.pipDateOfBirth.text = [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredDateOfBirth"];
    self.pipEmail.text = [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredEmail"];
    self.pipSocialSecurityNum.text = [self.myPatientJSON valueForKey:@"primaryInsurancePrimaryInsuredSocialSecurityNumber"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
