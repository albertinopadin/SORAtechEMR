//
//  PatientSearchViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@interface PatientSearchViewController : UIViewController

@property (strong, nonatomic) Prescriber *myDoctor;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;

- (IBAction)searchButtonPressed:(id)sender;

@end
