//
//  NPContactsViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPContactsViewController : UIViewController

// Employer
@property (strong, nonatomic) IBOutlet UITextField *employerName;
@property (strong, nonatomic) IBOutlet UITextField *employerAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *employerAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *employerCity;
@property (strong, nonatomic) IBOutlet UITextField *employerState;
@property (strong, nonatomic) IBOutlet UITextField *employerZipCode;
@property (strong, nonatomic) IBOutlet UITextField *employerPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *employerEmail;

// Emergency Contact
@property (strong, nonatomic) IBOutlet UITextField *emergencyCFirstName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCMiddleName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCPaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCMaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCCity;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCState;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCZipCode;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCEmail;

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

// To check if any of the text fields are empty
@property (strong, nonatomic) NSArray *textFields;

- (BOOL)textFieldEmpty;

@end
