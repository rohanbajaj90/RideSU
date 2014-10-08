//
//  requestPasswordPageViewController.m
//  RideSU
//
//  Created by Rohan Bajaj on 7/27/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "requestPasswordPage.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"


@interface requestPasswordPage ()

@end

@implementation requestPasswordPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"\n request password page \n");
    
    _emailIdField.delegate = self;
    [self hideOnTouchOutside];
}

-(void) hideOnTouchOutside{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [_emailIdField resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)requestPasswordButton:(id)sender {
    
    
    if (_emailIdField.text.length!=0) {
        PFObject *player = [PFObject objectWithClassName:@"requestPassword"];//1
        [player setObject:[NSString stringWithFormat:@"%@@syr.edu", _emailIdField.text]forKey:@"syrID"];
        [player setObject:_emailIdField.text forKey:@"userID"];
        
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Sending Request";
        [hud show:YES];
        
        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [hud hide:YES];
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
                [_emailIdField resignFirstResponder];
                
                
                NSString * storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"afterRequestPassword"];
                [self presentViewController:vc animated:YES completion:nil];

            }
            else{
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Try later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
        }];
    }
    else //if (_emailIdField.text.length==0)
    {
    
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
    
   

    
}

- (IBAction)backButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"signInPage"];
    [self presentViewController:vc animated:YES completion:nil];
    
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

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
