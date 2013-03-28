//
//  ConditionCell.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) NSString *myCondition;
@property (strong, nonatomic) IBOutlet UITextField *condition;

- (IBAction)conditionChanged:(UITextField *)sender;


@end
