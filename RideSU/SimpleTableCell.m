//
//  SimpleTableCell.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/19/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell

@synthesize fromLabel = _fromLabel;
@synthesize toLabel = _toLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
