//
//  EditMedicinesViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditMedicinesViewController.h"

@interface EditMedicinesViewController ()

@property (nonatomic) BOOL editCond;

@end

@implementation EditMedicinesViewController

@synthesize editMedicinesTableView, editMedicinesTVC, editCond;

- (void)generateMedicineList:(NSInteger)patientID
{
    [self.editMedicinesTVC generateMedicinesFromPID:patientID];
}

- (void)saveEditedMedicinesWithPID:(NSInteger)patientID
{
    [self.editMedicinesTVC saveEditedMedicinesWithPID:patientID];
}

- (IBAction)addMedicineCell:(id)sender
{
    [self.editMedicinesTVC addMedicineCell];
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
    editCond = false;
    self.editMedicinesTVC = [[EditMedicinesTableController alloc] init];
    
    self.editMedicinesTVC.tableView = self.editMedicinesTableView;
    self.editMedicinesTableView.delegate = self.editMedicinesTVC;
    self.editMedicinesTableView.dataSource = self.editMedicinesTVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enableDelete:(id)sender
{
    // Toggle edit variable
    editCond = !editCond;
    [self.editMedicinesTVC setEditing:editCond animated:YES];
}

@end
