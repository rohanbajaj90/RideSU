//
//  ViewController.h
//  RideSU
//
//  Created by Rohan Bajaj on 7/27/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface signInPage : UIViewController<UITextFieldDelegate, CustomIOS7AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButton:(id)sender;

- (IBAction)registerButton:(id)sender;

@property (nonatomic) NSTimeInterval secondsToShow;

@end
