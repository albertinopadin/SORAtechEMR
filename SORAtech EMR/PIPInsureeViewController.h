//
//  PIPInsureeViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/30/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface PIPInsureeViewController : UIViewController

@property (strong, nonatomic) NSDictionary *myPatientJSON;
@property (strong, nonatomic) IBOutlet UILabel *pipFullName;
@property (strong, nonatomic) IBOutlet UILabel *pipAddressLine1;
@property (strong, nonatomic) IBOutlet UILabel *pipAddressLine2;
@property (strong, nonatomic) IBOutlet UILabel *pipPhoneNum;
@property (strong, nonatomic) IBOutlet UILabel *pipEmail;
@property (strong, nonatomic) IBOutlet UILabel *pipDateOfBirth;
@property (strong, nonatomic) IBOutlet UILabel *pipSocialSecurityNum;

@end
