//
//  ConditionCell.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "ConditionCell.h"

@implementation ConditionCell

@synthesize condition, myCondition;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"In TextFieldDidBeginEditing in Cell");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"conditionCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)conditionChanged:(UITextField *)sender
{
    NSLog(@"In condition changed in Cell. The text is: %@", sender.text);
    self.myCondition = sender.text;
    NSLog(@"myCondition is %@", self.myCondition);
}
@end
