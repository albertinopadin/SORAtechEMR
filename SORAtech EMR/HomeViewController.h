//
//  HomeViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/17/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

- (IBAction)logoutButtonPressed:(id)sender;
- (void)incomingSegue:(NSString *)segueIdentifier;

@end
