//
//  PatientSearchResultTVC.h
//  Capstone_UI
//
//  Created by Albertino Padin on 3/6/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prescriber.h"

@interface PatientSearchResultTVC : UITableViewController

@property (strong, nonatomic) Prescriber *myDoctor;
@property (nonatomic) NSInteger patientIndex;
@property (strong, nonatomic) NSMutableArray *searchResultsArray;
@property (strong, nonatomic) IBOutlet UITableView *patientListTableView;

- (void)performSegueFromCellWithIndex:(NSInteger)index andName:(NSString *)segueName;

@end
