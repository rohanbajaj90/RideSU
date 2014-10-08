//
//  ViewController.m
//  RideSU
//
//  Created by Rohan Bajaj on 7/27/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addData];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) addData{

    
    
    
    PFObject *player = [PFObject objectWithClassName:@"User"];//1
    [player setObject:@"John2" forKey:@"userID"];
    [player setObject:@"test2" forKey:@"password"];
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [hud hide:YES];
        
        if (succeeded){
            NSLog(@"Object Uploaded!");
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
        
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
