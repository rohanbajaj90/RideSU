//
//  setPasswordFirstTime.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/2/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "setPasswordFirstTime.h"
#import "Parse/Parse.h"
#import "ALAlertBanner.h"
#import "MBProgressHUD.h"


NSString *password;

@interface setPasswordFirstTime ()

@end

@implementation setPasswordFirstTime



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _firstPassword.delegate = self;
    _secondPassword.delegate = self;
    [self hideOnTouchOutside];
    
    NSLog(@"\n\n set first password ...view did load");
    // Do any additional setup after loading the view.
    
    
}

-(void) hideOnTouchOutside{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [_firstPassword resignFirstResponder];
    [_secondPassword resignFirstResponder];
    
}



// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)updatePasswordButton:(id)sender {
    
   

    
    [_firstPassword resignFirstResponder];
    [_secondPassword resignFirstResponder];
    
    password = _firstPassword.text;

    
    if (_firstPassword.text.length == 0 || _secondPassword.text.length == 0) {
        NSLog(@"can't be 0");
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"can't be 0"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    else{
    
        if ([_firstPassword.text isEqual: _secondPassword.text]) {
            NSLog(@"matches...so update");
            
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [standardUserDefaults stringForKey:@"currentUserId"];


            
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"userID" equalTo:userId];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Updating pasword";
            [hud show:YES];

            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * user, NSError *error) {
                
                [hud hide:YES];
                if (!error) {
                    // Found UserStats
                    [user setObject:password forKey:@"password"];
                    [user setObject:@"set" forKey:@"setPassword"];

                    
                    NSLog(@" value updated");
                    
                    // Save
                    [user saveInBackground];
                    
                    
                    NSString * storyboardName = @"Main";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
                    [self presentViewController:vc animated:YES completion:nil];
                    
                    
                } else {
                    // Did not find any UserStats for the current user
                    NSLog(@"Error: %@", error);
                }
            }];
            
            
            
        }
        else{
            NSLog(@"doesn't match");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Don't match"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
    
    }
    
    _firstPassword.text=nil;
    _secondPassword.text=nil;
    
}
@end





