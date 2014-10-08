//
//  findRide.h
//  RideSU
//
//  Created by Rohan Bajaj on 8/16/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"
#import <MessageUI/MessageUI.h>



@interface findRide : UIViewController <UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>{


    IBOutlet IQDropDownTextField *fromPlacePicker;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButton:(id)sender;
- (IBAction)refreshButton:(id)sender;

- (IBAction)allPosts:(id)sender;

@end
 