//
//  NPEmployerViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/29/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPEmployerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *employerName;
@property (strong, nonatomic) IBOutlet UITextField *employerAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *employerAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *employerPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *employerEmail;

@end
