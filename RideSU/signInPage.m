//
//  ViewController.m
//  RideSU
//
//  Created by Rohan Bajaj on 7/27/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "signInPage.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "requestPasswordPage.h"
#import "ALAlertBanner.h"


@interface signInPage ()

@end

@implementation signInPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loginIdField.delegate = self;
    _passwordField.delegate=self;
    [self hideOnTouchOutside];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) hideOnTouchOutside{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [_loginIdField resignFirstResponder];
    [_passwordField resignFirstResponder];

}



// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    if (_loginIdField.text.length==0 || _passwordField.text.length == 0) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        
        // Add some custom content to the alert view
        [alertView setContainerView:[self createDemoView]];
        
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", @"Close3", nil]];
        [alertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];

    }
    else{
    
        PFQuery *query = [PFQuery queryWithClassName:@"User"]; //1
        [query whereKey:@"userID" equalTo:_loginIdField.text];//2
        [query whereKey:@"password" equalTo:_passwordField.text];//2
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Looooking...";
        [hud show:YES];


        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
            
            [hud hide:YES];

            if (!error) {
                
                if ([objects count] == 0) {
                    NSLog(@"No such combination");
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                                        style:ALAlertBannerStyleFailure
                                                                     position:ALAlertBannerPositionTop
                                                                        title:@"oops!"
                                                                     subtitle:@"no such combo"];
                    
                    /* 
                     optionally customize banner properties here...
                     */
                    
                    _secondsToShow = 5.0;
                    
                    
                    [banner show];
                    
                    [_loginIdField resignFirstResponder];
                    [_passwordField resignFirstResponder];
                    
                    [self clearFields];

                    
                    
                }
                else{
                NSLog(@"Successfully retrieved: %@", objects);
                    
                    
                    
                                               
                    
                    [_loginIdField resignFirstResponder];
                    [_passwordField resignFirstResponder];
                    
                    [self clearFields];
                    
                    
                    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                                        style:ALAlertBannerStyleSuccess
                                                                     position:ALAlertBannerPositionTop
                                                                        title:@"awesome!"
                                                                     subtitle:@""];
                
                    
                    _secondsToShow = 5.0;
                    
                    
                    [banner show];
                    
//                    for (PFObject *user in objects) {
//                        NSArray *friends = [user objectForKey:@"friends"];
//                        
//                        for (NSString *friend in friends) {
//                            NSLog(@"Friend is '%@'", friend);
//                        }
//                    }


                    
                }
                
                
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
            }
        }];
    
    
    }
    
}

-(void) clearFields{

    _loginIdField.text=nil;
    _passwordField.text=nil;

}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    [imageView setImage:[UIImage imageNamed:@"demo"]];
    [demoView addSubview:imageView];
    
    return demoView;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}







- (IBAction)registerButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"requestPassword"];
    [self presentViewController:vc animated:YES completion:nil];
   
}
@end
