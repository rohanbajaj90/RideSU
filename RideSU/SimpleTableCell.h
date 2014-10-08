//
//  SimpleTableCell.h
//  RideSU
//
//  Created by Rohan Bajaj on 8/19/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerSeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSeatsLabel;
@end
