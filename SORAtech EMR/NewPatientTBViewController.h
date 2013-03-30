//
//  NewPatientTBViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/28/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Prescriber.h"

@interface NewPatientTBViewController : UITabBarController <UIAlertViewDelegate>

@property (strong, nonatomic) Prescriber *myDoctor;

@end
