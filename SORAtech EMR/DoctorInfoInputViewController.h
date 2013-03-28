//
//  DoctorInfoInputViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/25/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@interface DoctorInfoInputViewController : UIViewController

@property (strong, nonatomic) Prescriber *myDoctor;

@property (strong, nonatomic) IBOutlet UITextField *doctorFullNameTB;
@property (strong, nonatomic) IBOutlet UITextField *addressLine1TB;
@property (strong, nonatomic) IBOutlet UITextField *addressLine2TB;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTB;
@property (strong, nonatomic) IBOutlet UITextField *emailTB;

@end
