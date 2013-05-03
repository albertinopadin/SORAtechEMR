//
//  BTCopyToSMViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/2/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCopyToSMViewController : UIViewController

@property (strong, nonatomic) NSDictionary *myPatientJSON;

@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *patientIdLabel;
@property (strong, nonatomic) volatile IBOutlet UILabel *cpyStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *btConnectionStatus;

- (IBAction)copyToSmartCard:(id)sender;

@end