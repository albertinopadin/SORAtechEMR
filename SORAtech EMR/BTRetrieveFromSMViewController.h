//
//  BTRetrieveFromSMViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRetrieveFromSMViewController : UIViewController

@property (strong, nonatomic) NSDictionary *retrievedPatientJSON;

@property (strong, nonatomic) volatile IBOutlet UILabel *retrieveStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *btConnectionStatus;
@property (strong, nonatomic) IBOutlet UITextView *contentsOfSmartCard;

- (void)readFinished;

- (IBAction)retrieveFromSmartCard:(id)sender;
- (IBAction)prepopulateFieldsWithSCInfo:(id)sender;

@end
