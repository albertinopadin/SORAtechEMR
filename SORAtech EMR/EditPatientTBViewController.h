//
//  EditPatientTBViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPatientTBViewController : UITabBarController <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *myPatientJSON;

- (IBAction)doneEditingPatient:(id)sender;

@end
