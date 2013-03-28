//
//  PrescriberViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@interface PrescriberViewController : UIViewController

@property (strong, nonatomic) Prescriber *myPrescriber;

@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end
