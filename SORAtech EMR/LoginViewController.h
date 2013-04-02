//
//  LoginViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/16/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginKeyTextField;

- (IBAction)loginButtonPressed:(id)sender;

@end
