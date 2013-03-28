//
//  DoctorInfoInputViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/25/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "DoctorInfoInputViewController.h"
#import "STAppDelegate.h"
#import "HomeViewController.h"

@interface DoctorInfoInputViewController ()

@end

@implementation DoctorInfoInputViewController

@synthesize myDoctor, doctorFullNameTB, addressLine1TB, addressLine2TB, phoneNumberTB, emailTB;

//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
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
    
    self.doctorFullNameTB.text = self.myDoctor.fullName;
    self.addressLine1TB.text = self.myDoctor.addressLine1;
    self.addressLine2TB.text = self.myDoctor.addressLine2;
    self.phoneNumberTB.text = self.myDoctor.phoneNumber;
    self.emailTB.text = self.myDoctor.email;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.myDoctor.fullName = self.doctorFullNameTB.text;
    self.myDoctor.addressLine1 = self.addressLine1TB.text;
    self.myDoctor.addressLine2 = self.addressLine2TB.text;
    self.myDoctor.phoneNumber = self.phoneNumberTB.text;
    self.myDoctor.email = self.emailTB.text;
    
    //Save the information using the context
    NSError *saveError = nil;
    
    [self.managedObjectContext save:&saveError];
    
    NSLog(@"Modified Doctor!");
    
    UINavigationController *nav = [segue destinationViewController];
    HomeViewController *hvc = [[nav viewControllers] objectAtIndex:0];
    hvc.myDoctor = self.myDoctor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
