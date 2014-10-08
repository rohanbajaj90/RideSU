//
//  afterRequestPassword.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/2/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "afterRequestPassword.h"

@interface afterRequestPassword ()

@end

@implementation afterRequestPassword

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
    
    NSLog(@"\n view did load...afterRequestPassword\n");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backToLoginPage:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"signInPage"];
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}
@end
