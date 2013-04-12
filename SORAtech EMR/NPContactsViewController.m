//
//  NPContactsViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPContactsViewController.h"

@interface NPContactsViewController ()

@end

@implementation NPContactsViewController

@synthesize employerName, employerAddressLine1, employerAddressLine2, employerPhoneNumber, employerEmail, employerCity, employerState, employerZipCode;
@synthesize emergencyCFirstName, emergencyCMiddleName, emergencyCPaternalLastName, emergencyCMaternalLastName, emergencyCAddressLine1, emergencyCAddressLine2, emergencyCPhoneNumber, emergencyCEmail, emergencyCCity, emergencyCState, emergencyCZipCode;
@synthesize myScrollView, textFields;


- (BOOL)textFieldEmpty
{
    textFields = [NSArray arrayWithObjects:employerName, employerAddressLine1, employerAddressLine2, employerCity, employerState, employerZipCode, employerPhoneNumber, employerEmail, emergencyCFirstName, emergencyCMiddleName, emergencyCPaternalLastName, emergencyCMaternalLastName, emergencyCAddressLine1, emergencyCAddressLine2, emergencyCCity, emergencyCState, emergencyCZipCode, emergencyCPhoneNumber, emergencyCEmail, nil];
    
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
    self.myScrollView.contentSize = CGSizeMake(768, 1200);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
