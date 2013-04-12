//
//  NPConditionsViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPConditionsViewController.h"

@interface NPConditionsViewController ()

@end

@implementation NPConditionsViewController

@synthesize npConditionsTableView, npConditionsTVC;
@synthesize textConditionsList = _textConditionsList;

// Non-default getter for the conditions List
- (NSMutableArray *)textConditionsList
{
    _textConditionsList = [self.npConditionsTVC textConditionsList];
    return _textConditionsList;
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
    
    self.npConditionsTVC = [[NPConditionsTableController alloc] init];
    
    self.npConditionsTVC.tableView = self.npConditionsTableView;
    self.npConditionsTableView.delegate = self.npConditionsTVC;
    self.npConditionsTableView.dataSource = self.npConditionsTVC;
    
    // Pre-add Five Cells...
    for (int i = 0; i < 3; i++) {
        [self addCondition:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCondition:(id)sender
{
    [self.npConditionsTVC addNewConditionCell];
}
@end
