//
//  PrescriberViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PrescriberViewController.h"
#import "STAppDelegate.h"

@interface PrescriberViewController ()

@end

@implementation PrescriberViewController

@synthesize myPrescriber, fullNameLabel, addressLine1Label, addressLine2Label, phoneNumberLabel, emailLabel;

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
    
    self.fullNameLabel.text = self.myPrescriber.fullName;
    self.addressLine1Label.text = self.myPrescriber.addressLine1;
    self.addressLine2Label.text = self.myPrescriber.addressLine2;
    self.phoneNumberLabel.text = self.myPrescriber.phoneNumber;
    self.emailLabel.text = self.myPrescriber.email;
    
    NSLog(@"myPrescriber is: %@",self.myPrescriber);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
