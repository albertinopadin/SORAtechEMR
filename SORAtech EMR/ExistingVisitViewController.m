//
//  ExistingVisitViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "ExistingVisitViewController.h"

@interface ExistingVisitViewController ()

@end

@implementation ExistingVisitViewController

@synthesize myVisit, date, bloodPressure, pulse, temperature, height, weight, notes;

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
    
    self.date.text = self.myVisit.date;
    self.bloodPressure.text = [NSString stringWithFormat:@"%@ / %@", self.myVisit.systolicBloodPressure, self.myVisit.diastolicBloodPressure];
    self.pulse.text = self.myVisit.pulse;
    self.temperature.text = self.myVisit.temperature;
    self.height.text = self.myVisit.height;
    self.weight.text = self.myVisit.weight;
    self.notes.text = self.myVisit.notes;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
