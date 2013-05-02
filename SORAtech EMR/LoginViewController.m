//
//  LoginViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/16/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "LoginViewController.h"
#import "STAppDelegate.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginKeyTextField;

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
        // This method is not called, so we do not initialize here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set up text field so it responds to enter key:
    self.loginKeyTextField.delegate = self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginButtonPressed:textField];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSError *e, *e2 = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest *loginRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/isValidKey/?key=%@", loginKeyTextField.text]]];
    
    NSData *loginData = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&e2];
    
    if (!loginData) {
        NSLog(@"loginData is nil");
        NSLog(@"Error: %@", e);
    }
    
    
    // Check if valid login
    NSString *validLogin = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
    
    if ([validLogin isEqualToString:@"true"])
    {
        NSLog(@"Succesful Login");
        
        // Storing the key in the keychain for persistent secure storage
        KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
        [keychainStore setObject:loginKeyTextField.text forKey:CFBridgingRelease(kSecValueData)];
        
        //Proceed with segue
        [self performSegueWithIdentifier:@"SuccessfulLoginSegue" sender:self];
    }
    else
    {
        // check for status code 403
        //                UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"There was a problem with the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //                [loginError show];
        
        UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"You have typed an incorrect login key" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginError show];
    }
    
}

@end
