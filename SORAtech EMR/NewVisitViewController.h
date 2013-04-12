//
//  NewVisitViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visit.h"
#import "Patient.h"
#import "ConditionsTableViewController.h"
#import "MedicationsTableViewController.h"
#import "Prescriber.h"

@interface NewVisitViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Prescriber *myDoctor;
@property (strong, nonatomic) Visit *visit;
@property (strong, nonatomic) NSArray *visitList;
@property (strong, nonatomic) Patient *myPatient;
@property (strong, nonatomic) NSArray *conditionsArray;
@property (strong, nonatomic) NSArray *medicationsArray;
@property (strong, nonatomic) ConditionsTableViewController *conditionsTableVC;
@property (strong, nonatomic) MedicationsTableViewController *medicationsTableVC;


@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *systolicBPField;
@property (strong, nonatomic) IBOutlet UITextField *diastolicBPField;
@property (strong, nonatomic) IBOutlet UITextField *pulseField;
@property (strong, nonatomic) IBOutlet UITextField *temperatureField;
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UITextView *visitNotes;

//@property (strong, nonatomic) IBOutlet UITableView *conditionsTable;
//@property (strong, nonatomic) IBOutlet UITableView *medicationsTable;
//
//- (IBAction)addConditionButtonPressed:(id)sender;
//- (IBAction)addMedicationButtonPressed:(id)sender;

@end
