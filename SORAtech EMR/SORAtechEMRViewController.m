//
//  SORAtechEMRViewController.m
//  SORAtechEMR_mockup_1
//
//  Created by Albertino Padin on 2/19/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "SORAtechEMRViewController.h"
#import "KeychainItemWrapper.h"

@interface SORAtechEMRViewController ()

@end

@implementation SORAtechEMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // See if the user has already logged in (keychain exists and valid)
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    //NSLog(@"key at splashscreen is: %@", key);
    
    if ([key isEqualToString:@""] || key == nil)
    {
        [self performSelector:@selector(doSegue) withObject:nil afterDelay:2.00];
    }
    else
    {
        //NSError *error, *e, *e2 = nil;
        NSError *e, *e2 = nil;
        NSHTTPURLResponse *response = nil;
        
        //NSURLRequest *loginRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/doctors/?key=%@", key]]];
        NSURLRequest *loginRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/isValidKey/?key=%@", key]]];
        
        NSData *loginData = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&e2];
        
        if (!loginData) {
            NSLog(@"loginData is nil");
            NSLog(@"Error: %@", e);
        }
        
        NSString *validLogin = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
        
        if ([validLogin isEqualToString:@"true"])
        {
            NSLog(@"Succesful Login");
            
            //Proceed past login screen, as the user is already logged in
            [self performSelector:@selector(doSegueAlreadyLoggedIn) withObject:nil afterDelay:1.00];
        }
        else
        {
            // Wrong key, so go to login screen
            [self performSelector:@selector(doSegue) withObject:nil afterDelay:2.00];
        }
        
    }

}

- (void)doSegue
{
    [self performSegueWithIdentifier:@"AfterIntroSegue" sender:self];
}

- (void)doSegueAlreadyLoggedIn
{
    [self performSegueWithIdentifier:@"AfterSplashKCExistsSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
