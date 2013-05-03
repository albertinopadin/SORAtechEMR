//
//  NPMedicinesViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPMedicinesViewController.h"

@interface NPMedicinesViewController ()

@end

@implementation NPMedicinesViewController

@synthesize npMedicinesTVC, npMedicationsTableView, myPatientId;

- (void)saveMedications:(NSInteger)patientID
{
    // Pass message to save medications to our table view controller
    [self.npMedicinesTVC saveMedications:patientID];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.npMedicinesTVC = [[NPMedicinesTableController alloc] init];
    
    self.npMedicinesTVC.tableView = self.npMedicationsTableView;
    self.npMedicationsTableView.delegate = self.npMedicinesTVC;
    self.npMedicationsTableView.dataSource = self.npMedicinesTVC;
    
    // Pre-add Five Cells...
    for (int i = 0; i < 3; i++) {
        [self addNewMedication:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewMedication:(id)sender
{
    [self.npMedicinesTVC addNewMedicineCell];
}

@end
