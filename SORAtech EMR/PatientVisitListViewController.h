//
//  PatientVisitListViewController.h
//  Capstone_UI
//
//  Created by Albertino Padin on 3/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Prescriber.h"

@interface PatientVisitListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Prescriber *myDoctor;
@property (retain, nonatomic) Patient *myPatient;
@property (retain, nonatomic) NSMutableArray *visitList, *notesList;
@property (strong, nonatomic) UITableViewController *visitListTableViewController;

@property (strong, nonatomic) IBOutlet UITableView *visitListTableView;
@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *patientPhotoView;

@end
