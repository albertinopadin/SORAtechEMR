//
//  NPEmergencyContactViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPEmergencyContactViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *emergencyCFirstName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCMiddleName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCPaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCMaternalLastName;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCEmail;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCCity;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCState;
@property (strong, nonatomic) IBOutlet UITextField *emergencyCZipCode;

// To check if any of the text fields are empty
@property (strong, nonatomic) NSArray *textFields;

- (BOOL)textFieldEmpty;

@end
