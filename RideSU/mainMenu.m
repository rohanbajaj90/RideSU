//
//  mainMenu.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "mainMenu.h"


@interface mainMenu ()

@end

@implementation mainMenu



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"main menu");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)giveRideButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"giveRideScreen"];
    [self presentViewController:vc animated:YES completion:nil];

    
    
}

- (IBAction)lookForRideButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"findRide"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)mailMe:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"SU RideShare";
    // Email Content
    
    
    
    
    
    NSString *messageBody = @"Questions / Complaints / Suggestions / Feedback .... anything else? \n ";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"rbajaj@syr.edu"]];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}



- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
