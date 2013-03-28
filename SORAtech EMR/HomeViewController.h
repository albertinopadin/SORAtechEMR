//
//  HomeViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) Prescriber *myDoctor;

- (IBAction)logoutButtonPressed:(id)sender;

@end
