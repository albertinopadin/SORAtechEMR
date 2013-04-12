//
//  EditConditionsViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditConditionsViewController.h"

@interface EditConditionsViewController ()

@property (nonatomic) BOOL editCond;

@end

@implementation EditConditionsViewController

@synthesize editConditionsTableView, editConditionsTVC, editCond;
@synthesize conditionsList = _conditionsList;

//- (NSMutableArray *)conditionsList
//{
//    if (_conditionsList == nil)
//    {
//        _conditionsList = self.editConditionsTVC.conditionsList;
//    }
//    return _conditionsList;
//}

- (void)generateConditionsList:(NSInteger)patientID
{
    [self.editConditionsTVC generateConditionsFromPID:patientID];
}

- (void)saveEditedConditionsWithPID:(NSInteger)patientID
{
    [self.editConditionsTVC saveEditedConditionsWithPID:patientID];
}

- (IBAction)addConditionCell:(id)sender
{
    [self.editConditionsTVC addConditionCell];
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
    self.editConditionsTVC = [[EditConditionsTableController alloc] init];
    
    self.editConditionsTVC.tableView = self.editConditionsTableView;
    self.editConditionsTableView.delegate = self.editConditionsTVC;
    self.editConditionsTableView.dataSource = self.editConditionsTVC;
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
    [self.editConditionsTVC setEditing:editCond animated:YES];
}
@end
