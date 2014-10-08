//
//  requestPasswordPageViewController.h
//  RideSU
//
//  Created by Rohan Bajaj on 7/27/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"


@interface requestPasswordPage : UIViewController<UITextFieldDelegate, CustomIOS7AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailIdField;
- (IBAction)requestPasswordButton:(id)sender;

- (IBAction)backButton:(id)sender;
@end
