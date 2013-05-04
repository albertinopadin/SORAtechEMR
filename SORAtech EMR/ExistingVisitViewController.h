//
//  ExistingVisitViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExistingVisitViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *myPatientJSON;
@property (strong, nonatomic) NSDictionary *myVisitJSON;

@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *bloodPressure;
@property (strong, nonatomic) IBOutlet UILabel *pulse;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UITextView *notes;

//@property (strong, nonatomic) IBOutlet UITableView *conditionsDiagnosedTableView;
//@property (strong, nonatomic) IBOutlet UITableView *medicationsPrescribedTableView;

@end
