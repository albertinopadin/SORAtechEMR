//
//  EditVisitViewController.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditVisitViewController : UIViewController

@property (strong, nonatomic) NSDictionary *editVisit;
@property (strong, nonatomic) NSDictionary *myPatientJSON;

@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *systolicBPField;
@property (strong, nonatomic) IBOutlet UITextField *diastolicBPField;
@property (strong, nonatomic) IBOutlet UITextField *pulseField;
@property (strong, nonatomic) IBOutlet UITextField *temperatureField;
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UITextView *visitNotes;

- (IBAction)doneEditingVisit:(id)sender;

@end
