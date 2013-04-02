//
//  ExistingVisitCondCell.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/2/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "ExistingVisitCondCell.h"

@implementation ExistingVisitCondCell

@synthesize exVisitCondition;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
