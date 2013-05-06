//
//  NewPatientMedicationCell.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPatientMedicationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellNumLabel;
@property (strong, nonatomic) IBOutlet UITextField *medicationNameTF;
@property (strong, nonatomic) IBOutlet UITextField *dosageTF;
//@property (strong, nonatomic) IBOutlet UITextField *frequencyTF;
//@property (strong, nonatomic) IBOutlet UITextField *purposeTF;

@end
