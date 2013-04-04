//
//  EditPatientTBViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"
#import "Patient.h"

@interface EditPatientTBViewController : UITabBarController <UIAlertViewDelegate>

@property (strong, nonatomic) Prescriber *myDoctor;
@property (strong, nonatomic) Patient *myPatient;

- (IBAction)doneEditingPatient:(id)sender;

@end
