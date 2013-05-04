//
//  SIPInsureeViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/30/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface SIPInsureeViewController : UIViewController

@property (strong, nonatomic) NSDictionary *myPatientJSON;
@property (strong, nonatomic) IBOutlet UILabel *sipFullName;
@property (strong, nonatomic) IBOutlet UILabel *sipAddressLine1;
@property (strong, nonatomic) IBOutlet UILabel *sipAddressLine2;
@property (strong, nonatomic) IBOutlet UILabel *sipPhoneNum;
@property (strong, nonatomic) IBOutlet UILabel *sipEmail;
@property (strong, nonatomic) IBOutlet UILabel *sipDateOfBirth;
@property (strong, nonatomic) IBOutlet UILabel *sipSocialSecurityNum;


@end
