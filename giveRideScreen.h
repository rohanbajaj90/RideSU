//
//  giveRideScreen.h
//  RideSU
//
//  Created by Rohan Bajaj on 8/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"
#import "RPVerticalStepper.h"



@interface giveRideScreen : UIViewController <RPVerticalStepperDelegate> {

    IBOutlet IQDropDownTextField *fromPlace; 

    IBOutlet IQDropDownTextField *toPlace;
}
- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *selectDate;

@property (weak, nonatomic) IBOutlet UIImageView *morningText;
@property (weak, nonatomic) IBOutlet UIImageView *afternoonText;
@property (weak, nonatomic) IBOutlet UIImageView *eveningText;
@property (weak, nonatomic) IBOutlet UIImageView *AnytimeText;
@property (weak, nonatomic) IBOutlet UILabel *dayName;
@property (weak, nonatomic) IBOutlet UILabel *dayNumber;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *year;


@property (weak, nonatomic) IBOutlet RPVerticalStepper *priceStepper;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet RPVerticalStepper *seatsStepper;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;

- (IBAction)post:(id)sender;
@end
