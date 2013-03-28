//
//  ExistingVisitViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visit.h"

@interface ExistingVisitViewController : UIViewController

@property (strong, nonatomic) Visit *myVisit;

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *bloodPressure;
@property (strong, nonatomic) IBOutlet UILabel *pulse;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *weight;
@property (strong, nonatomic) IBOutlet UITextView *notes;

@end
