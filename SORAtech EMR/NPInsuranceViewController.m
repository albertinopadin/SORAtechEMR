//
//  NPInsuranceViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPInsuranceViewController.h"

@interface NPInsuranceViewController ()

@end

@implementation NPInsuranceViewController

@synthesize myScrollView, textFields;

@synthesize primaryInsuranceName, primaryInsurancePolicyNum, primaryInsuranceGroupNum, relationshipToPrimaryInsuree;

@synthesize PIFirstName, PIMiddleName, PIPaternalLastName, PIMaternalLastName, PIDateofBirth, PISocialSecurityNum, PIAddressLine1, PIAddressLine2, PIState, PICity, PIZipCode, PIPhoneNum, PIEmail;

@synthesize secondaryInsuranceName, secondaryInsurancePolicyNum, secondaryInsuranceGroupNum, relationshipToSecondaryInsuree;

@synthesize SIFirstName, SIMiddleName, SIPaternalLastName, SIMaternalLastName, SIDateofBirth, SISocialSecurityNum, SIAddressLine1, SIAddressLine2, SIState, SICity, SIZipCode, SIPhoneNum, SIEmail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldEmpty
{
    textFields = [NSArray arrayWithObjects:primaryInsuranceName, primaryInsurancePolicyNum, primaryInsuranceGroupNum, relationshipToPrimaryInsuree, PIFirstName, PIMiddleName, PIPaternalLastName, PIMaternalLastName, PIDateofBirth, PISocialSecurityNum, PIAddressLine1, PIAddressLine2, PIState, PICity, PIZipCode, PIPhoneNum, PIEmail, secondaryInsuranceName, secondaryInsurancePolicyNum, secondaryInsuranceGroupNum, relationshipToSecondaryInsuree, SIFirstName, SIMiddleName, SIPaternalLastName, SIMaternalLastName, SIDateofBirth, SISocialSecurityNum, SIAddressLine1, SIAddressLine2, SIState, SICity, SIZipCode, SIPhoneNum, SIEmail, nil];
    
    BOOL isEmpty = NO;
    
    for (UITextField *tf in textFields)
    {
        if ([tf.text length] == 0)
        {
            isEmpty = YES;
        }
    }
    
    return isEmpty;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myScrollView.contentSize = CGSizeMake(768, 1600);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
