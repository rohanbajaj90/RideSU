//
//  findRide.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/16/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "findRide.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "SimpleTableCell.h"
#import "ALAlertBanner.h"


@interface findRide ()

@end

@implementation findRide{

    NSArray *tableData;    // for from place
    NSArray *tableDataToLocation;
    NSArray *tableDataDate;
    NSArray *tableDataTime;
    NSArray *tableDataDrivers;
    NSArray *tableDataPricePerSeat;
    NSArray *tableDataTotalSeats;
    NSArray *tableDataObjectIds;

}

NSDate *DateToday;

NSMutableArray *usersArray;
NSMutableArray *fromArray;
NSMutableArray *toArray;
NSMutableArray *datesArray;
NSMutableArray *timesArray;
NSMutableArray *pricesArray;
NSMutableArray *seatsArray;
NSMutableArray *objectIdArray;



NSMutableArray *places;

NSString * currentlySelectedObjectId;
NSString * driverOfCurrentlySelected;









- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load...find ride");
    
    [self TodaysDate];
   
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    
        //  parse data downloaded in background
        [self loadDataFromParse];
        
       
    
    
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    

    
    [self getListOfPlaces];
    [self runPlaceList];
    
    [self fromToPicker];
    
    

}











- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //
    // wait till fromArray filled with something to load data into cells
    //
    if ([fromArray count]!=0 ) {
        
        NSLog(@"running cellForRowAtIndexPath..........");
       
       //tableData = fromArray;
        
        cell.fromLabel.text = [tableData objectAtIndex:indexPath.row];
        cell.toLabel.text = [tableDataToLocation objectAtIndex:indexPath.row];
        cell.dateLabel.text = [tableDataDate objectAtIndex:indexPath.row];
        cell.timeLabel.text = [tableDataTime objectAtIndex:indexPath.row];
        
//        cell.driverLabel.text = [tableDataDrivers objectAtIndex:indexPath.row];
        
        cell.driverLabel.text = [NSString stringWithFormat:@"%@@syr.edu", [tableDataDrivers objectAtIndex:indexPath.row]];


        
        
        
        cell.pricePerSeatLabel.text = [tableDataPricePerSeat objectAtIndex:indexPath.row];
        cell.totalSeatsLabel.text = [tableDataTotalSeats objectAtIndex:indexPath.row];

    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}



-(void) TodaysDate{

    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM-dd-yyyy"];
    [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTimeAgain = [dateFormatter3 stringFromDate:[NSDate date]];
    // NSLog(@"currentTimeAgain %@",currentTimeAgain);
    
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *currentTimeDateNSDate = [[NSDate alloc] init];
    currentTimeDateNSDate = [dateFormatter dateFromString:currentTimeAgain];
//    NSLog(@"Today's NSDate format %@",currentTimeDateNSDate);


    DateToday = currentTimeDateNSDate;
}

-(void) checkArrayPopulation{

    NSLog(@"total trips %lu",(unsigned long)[usersArray count]);
    
    for (int i=0; i< [usersArray count]; i++) {
        NSLog(@"\n");
        NSLog(@"%@",[usersArray objectAtIndex:i]);
        NSLog(@"%@",[fromArray objectAtIndex:i]);
        NSLog(@"%@",[toArray objectAtIndex:i]);
        NSLog(@"%@",[datesArray objectAtIndex:i]);
        NSLog(@"%@",[timesArray objectAtIndex:i]);
        NSLog(@"%@",[pricesArray objectAtIndex:i]);
        NSLog(@"%@",[seatsArray objectAtIndex:i]);
        NSLog(@"%@",[objectIdArray objectAtIndex:i]);

        
    }

}

-(void) loadDataFromParse{
    
    
    
    [usersArray removeAllObjects];
    [fromArray removeAllObjects];
    [toArray removeAllObjects];
    [datesArray removeAllObjects];
    [timesArray removeAllObjects];
    [pricesArray removeAllObjects];
    [seatsArray removeAllObjects];
    [objectIdArray removeAllObjects];
    
    usersArray = [[NSMutableArray alloc] init];
    fromArray = [[NSMutableArray alloc] init];
    toArray = [[NSMutableArray alloc] init];
    datesArray = [[NSMutableArray alloc] init];
    timesArray = [[NSMutableArray alloc] init];
    pricesArray = [[NSMutableArray alloc] init];
    seatsArray = [[NSMutableArray alloc] init];
    objectIdArray = [[NSMutableArray alloc] init];

    
 


    PFQuery *query = [PFQuery queryWithClassName:@"Trips"]; //1

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading From Parse";
    [hud show:YES];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        [hud hide:YES];
        if (!error) {
            
            for (PFObject *trips in objects) {
            
                NSString *tripDateString = [trips objectForKey:@"Date"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                NSDate *tripNSDate = [[NSDate alloc] init];
                tripNSDate = [dateFormatter dateFromString:tripDateString];
                
                

              //  NSLog(@"Trip Date: %@",tripDateString);
               
                
                if ([tripNSDate compare:DateToday] == NSOrderedDescending) {
                    //NSLog(@"trip in future");
                    // NSLog(@"NSDate trip %@",tripNSDate);
                    
                    NSString *userId = [trips objectForKey:@"user"];
                   
                                        
                    
                    NSString *fromPlace = [trips objectForKey:@"From"];
                    NSString *toPlace = [trips objectForKey:@"To"];
                    NSString *whenDate = [trips objectForKey:@"Date"];
                    NSString *time = [trips objectForKey:@"time"];
                    NSNumber *seatPrice = [trips objectForKey:@"pricePerSeat"];
                    NSNumber *seatsAvailable = [trips objectForKey:@"totalSeats"];
                    
                    NSString *StringSeatsAvailable = [seatsAvailable stringValue];
                    NSString *StringPricePerSeat = [seatPrice stringValue];
                    
                    NSString *ObjectId = [trips objectId];


                    
                    [usersArray addObject:userId];
                    [fromArray addObject:fromPlace];
                    [toArray addObject:toPlace];
                    [datesArray addObject:whenDate];
                    [timesArray addObject:time];

                 [seatsArray addObject:StringSeatsAvailable];
                    [pricesArray addObject:StringPricePerSeat];
                    [objectIdArray addObject:ObjectId];


                    
                    

                    
                } else if ([tripNSDate compare:DateToday] == NSOrderedAscending) {
                    NSLog(@"trip expired...delete it from database");
                    [trips deleteInBackground];
                    
                    
                } else {
                   
                   // NSLog(@"trip today");
                     NSLog(@"NSDate trip %@",tripNSDate);
                    
                    
                    NSString *userId = [trips objectForKey:@"user"];
                    NSString *fromPlace = [trips objectForKey:@"From"];
                    NSString *toPlace = [trips objectForKey:@"To"];
                    NSString *whenDate = [trips objectForKey:@"Date"];
                    NSString *time = [trips objectForKey:@"time"];
                    NSNumber *seatPrice = [trips objectForKey:@"pricePerSeat"];
                    NSNumber *seatsAvailable = [trips objectForKey:@"totalSeats"];
                    NSString *objId = [trips objectId];
                    
                    NSString *StringSeatsAvailable = [seatsAvailable stringValue];
                    NSString *StringPricePerSeat = [seatPrice stringValue];
                    
                    
                    
                    [usersArray addObject:userId];
                    [fromArray addObject:fromPlace];
                    [toArray addObject:toPlace];
                    [datesArray addObject:whenDate];
                    [timesArray addObject:time];
                    [pricesArray addObject:StringPricePerSeat];
                    [seatsArray addObject:StringSeatsAvailable];
                    [objectIdArray addObject:objId];
                }

                
                
                
            }
            
            NSLog(@"Successfully retrieved: %@", objects);

            // put anything here..to be done at the end of retreving all objects
            // on retreiving everythng
            
            NSLog(@"checking array pop......");
            [self checkArrayPopulation];
            
            

            
            [self refreshButton:nil];
            
            
        } else {
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


- (IBAction)backButton:(id)sender {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    [self presentViewController:vc animated:YES completion:nil];

    
}

- (IBAction)refreshButton:(id)sender{
    
    
    fromPlacePicker.text=nil;
    
    tableData = fromArray;    // from location
    tableDataToLocation = toArray;
    tableDataDate = datesArray;
    tableDataTime = timesArray;
   
    tableDataTotalSeats = seatsArray;
    tableDataPricePerSeat = pricesArray;
    tableDataDrivers = usersArray;
    tableDataObjectIds = objectIdArray;

     [_tableView reloadData];


}

- (IBAction)allPosts:(id)sender {
    
    [self refreshButton:nil];
    
    fromPlacePicker.text = nil;
    
}









-(void) getListOfPlaces{
    
    NSLog(@"get list of places function");
    [places removeAllObjects];
    
    places = [[NSMutableArray alloc] init];
    
    
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"]; //1
    [query whereKey:@"Available" equalTo:@"YES"];//2
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Updating city list";
    [hud show:YES];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        
        [hud hide:YES];
        
        if (!error) {
            
            if ([objects count] == 0) {
                NSLog(@"No such combination");
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                                    style:ALAlertBannerStyleNotify
                                                                 position:ALAlertBannerPositionTop
                                                                    title:@""
                                                                 subtitle:@"no cities found"];
                
                /*
                 optionally customize banner properties here...
                 */
                
                
                [banner show];
                
            }
            
            else{
                NSLog(@"Successfully retrieved: %@", objects);
                
                
                for (PFObject *location in objects) {
                    
                    NSLog(@"running for places loop");
                    
                    NSString *placeName = [location objectForKey:@"Place"];
                    
                    [places addObject:placeName];
                    
                    
                }
                
                [places sortUsingSelector:@selector(caseInsensitiveCompare:)];

                
            }
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                                style:ALAlertBannerStyleFailure
                                                             position:ALAlertBannerPositionTop
                                                                title:@"oops!"
                                                             subtitle:@"so...I don't know, something went wrong"];
            
            [banner show];
            
            
            
        }
    }];
    
    

    
}


-(void) runPlaceList{
    
    NSLog(@"running city list");
    
    for (int i=0; i<[places count]; i++) {
        NSLog(@"%d,  %@",i,[places objectAtIndex:i]);
    }
    
}


-(void) fromToPicker{
    
    
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    
    
    // load toolbar for done...
    ////////
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    fromPlacePicker.inputAccessoryView = toolbar;
    
    
    // add values to the picker
    //////////
    
    [places sortUsingSelector:@selector(caseInsensitiveCompare:)];

    
    [fromPlacePicker setItemList:places];
    
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    
    [self updateFromTrips];
}


-(void)dismissPicker {
    
    [self.superclass endEditing:YES];
}




- (void)updateFromTrips {
    
//    NSLog(@"%@",fromPlacePicker.text);
    
    if (fromPlacePicker.text==nil) {
        NSLog(@"hey...select something man");
    }
    else{
    
    
    
    
    
    NSString *tripsStartingFrom = fromPlacePicker.text;
    NSLog(@"%@",tripsStartingFrom);
    
    
    
    
    
    
    NSMutableArray *reducedUsersArray;
    NSMutableArray *reducedFromArray;
    NSMutableArray *reducedToArray;
    NSMutableArray *reducedDatesArray;
    NSMutableArray *reducedTimesArray;
    NSMutableArray *reducedPricesArray;
    NSMutableArray *reducedSeatsArray;
    NSMutableArray *reducedObjectIdArray;

    
    [reducedUsersArray removeAllObjects];
    [reducedFromArray removeAllObjects];
    [reducedToArray removeAllObjects];
    [reducedDatesArray removeAllObjects];
    [reducedTimesArray removeAllObjects];
    [reducedPricesArray removeAllObjects];
    [reducedSeatsArray removeAllObjects];
        [reducedObjectIdArray removeAllObjects];

    
    
    reducedUsersArray = [[NSMutableArray alloc] init];
    reducedFromArray = [[NSMutableArray alloc] init];
    reducedToArray = [[NSMutableArray alloc] init];
    reducedDatesArray = [[NSMutableArray alloc] init];
    reducedTimesArray = [[NSMutableArray alloc] init];
    reducedPricesArray = [[NSMutableArray alloc] init];
    reducedSeatsArray = [[NSMutableArray alloc] init];
        reducedObjectIdArray = [[NSMutableArray alloc] init];


    

    for (int i=0; i<[fromArray count]; i++) {
        if ([[fromArray objectAtIndex:i] isEqualToString:tripsStartingFrom]) {
           
            // add to reduced array
            
            [reducedUsersArray addObject:[usersArray objectAtIndex:i]];
            [reducedFromArray addObject:[fromArray objectAtIndex:i]];
            [reducedToArray addObject:[toArray objectAtIndex:i]];
            [reducedDatesArray addObject:[datesArray objectAtIndex:i]];
            [reducedTimesArray addObject:[timesArray objectAtIndex:i]];
            [reducedPricesArray addObject:[pricesArray objectAtIndex:i]];
            [reducedSeatsArray addObject:[seatsArray objectAtIndex:i]];
            [reducedObjectIdArray addObject:[objectIdArray objectAtIndex:i]];


            
            
            
        }
        else{
            
         NSLog(@"not considering %@",[fromArray objectAtIndex:i]);
            
        }
    }
    
    
                tableData = reducedFromArray;    // from location
                tableDataToLocation = reducedToArray;
                tableDataDate = reducedDatesArray;
                tableDataTime = reducedTimesArray;
                tableDataTotalSeats = reducedSeatsArray;
                tableDataPricePerSeat = reducedPricesArray;
                tableDataDrivers = reducedUsersArray;
                tableDataObjectIds = reducedObjectIdArray;
    
    
    [_tableView reloadData];

    
    } // end of if case...
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.row); // you can see selected row number in your console;
    NSLog(@"%@",[tableData objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataToLocation objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataDate objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataTime objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataTotalSeats objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataPricePerSeat objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataDrivers objectAtIndex:indexPath.row]);
    NSLog(@"%@",[tableDataObjectIds objectAtIndex:indexPath.row]);
    
    
    

    
    NSString *selectedUser = [tableDataDrivers objectAtIndex:indexPath.row];
    NSString *selectedFrom = [tableData objectAtIndex:indexPath.row];
    NSString *selectedTo = [tableDataToLocation objectAtIndex:indexPath.row];
    NSString *selectedDate = [tableDataDate objectAtIndex:indexPath.row];
    NSString *selectedTime = [tableDataTime objectAtIndex:indexPath.row];
    
    
    
    //
    // update global variables of current selection
    //
    currentlySelectedObjectId = [tableDataObjectIds objectAtIndex:indexPath.row];
    driverOfCurrentlySelected = selectedUser;
    
    
    

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myId = [standardUserDefaults stringForKey:@"currentUser"];
    NSString *myEmailId = [NSString stringWithFormat:@"%@@syr.edu", myId];

    
    
    // Email Subject
    NSString *emailTitle = @"SU RideShare";
    // Email Content
    
     
    
    
    
    NSString *messageBody = [NSString stringWithFormat:@"Hey there! \n\n I'm interested in tagging along with you for the ride from: %@ to %@ on %@ \n\n So can I ? \n\n %@",selectedFrom, selectedTo, selectedDate, myEmailId];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@@syr.edu", selectedUser]
];
    
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSLog(@"pressed delete");
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myId = [standardUserDefaults stringForKey:@"currentUser"];
        NSLog(@"currently logged on user : %@",myId);
        
        NSString *tripDriver = [tableDataDrivers objectAtIndex:indexPath.row];
        NSString *tripToDeleteObjectId = [tableDataObjectIds objectAtIndex:indexPath.row];

        
        
        NSLog(@"Trip posted by user: %@",tripDriver);
        NSLog(@"ObjectId of current selection: %@",tripToDeleteObjectId);
        
        
        
        if ([tripDriver isEqual:myId]) {
            // then delete
            
           
            
            PFQuery *query = [PFQuery queryWithClassName:@"Trips"];
            [query whereKey:@"objectId" equalTo:tripToDeleteObjectId];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Deleting...";
                [hud show:YES];
                
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [hud hide:YES];

                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu combinations.", (unsigned long)objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"deleting");
                        
                        [object deleteInBackground];
                    }
                
                
                    // put anything here..to be done at the end of retreving all objects
                    // on retreiving everythng
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting "
                                                                    message:@"Records will be updated in a couple of minutes"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                    NSString * storyboardName = @"Main";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
                    [self presentViewController:vc animated:YES completion:nil];
                    
                
                }
                
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error "
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];

            
        }
        
        else{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"This isn't even your post!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        
        }
        
       
    
        
    
    }
}




@end
