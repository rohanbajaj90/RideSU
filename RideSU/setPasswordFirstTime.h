//
//  setPasswordFirstTime.h
//  RideSU
//
//  Created by Rohan Bajaj on 8/2/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setPasswordFirstTime : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
@property (weak, nonatomic) IBOutlet UITextField *secondPassword;

- (IBAction)updatePasswordButton:(id)sender;

@property (nonatomic) NSTimeInterval secondsToShow;


@end



// [standardUserDefaults setObject:userIdSave forKey:@"currentUserId"];