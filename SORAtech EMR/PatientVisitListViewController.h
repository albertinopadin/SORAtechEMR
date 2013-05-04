//
//  PatientVisitListViewController.h
//  Capstone_UI
//
//  Created by Albertino Padin on 3/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientVisitListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) NSDictionary *myPatientJSON;
@property (retain, nonatomic) NSMutableArray *visitList, *notesList;
@property (strong, nonatomic) UITableViewController *visitListTableViewController;

@property (strong, nonatomic) IBOutlet UITableView *visitListTableView;
@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *patientPhotoView;

@end
