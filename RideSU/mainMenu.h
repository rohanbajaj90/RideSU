//
//  mainMenu.h
//  RideSU
//
//  Created by Rohan Bajaj on 8/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface mainMenu : UIViewController<MFMailComposeViewControllerDelegate>
- (IBAction)giveRideButton:(id)sender;
- (IBAction)lookForRideButton:(id)sender;
- (IBAction)mailMe:(id)sender;

@end
