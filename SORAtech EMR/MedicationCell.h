//
//  MedicationCell.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *medication;
@property (strong, nonatomic) IBOutlet UITextField *dose;
@property (strong, nonatomic) IBOutlet UITextField *frequency;
@property (strong, nonatomic) IBOutlet UITextField *purpose;

@end
