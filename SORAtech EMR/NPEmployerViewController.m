//
//  NPEmployerViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPEmployerViewController.h"

@interface NPEmployerViewController ()

@end

@implementation NPEmployerViewController

@synthesize employerName, employerAddressLine1, employerAddressLine2, employerPhoneNum, employerEmail;

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
