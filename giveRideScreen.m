//
//  giveRideScreen.m
//  RideSU
//
//  Created by Rohan Bajaj on 8/9/14.
//  Copyright (c) 2014 Rohan Bajaj. All rights reserved.
//

#import "giveRideScreen.h"
#import "SACalendar.h"
#import "Parse/Parse.h"
#import "MBProgressHUD.h"
#import "ALAlertBanner.h"
#import "RPVerticalStepper.h"



@interface giveRideScreen ()

@end

@implementation giveRideScreen



int timeOption=3;
BOOL dateSelected = FALSE;
NSString * DateToUpload;

NSDate *DateToday;
NSDate *SelectedDate;


SACalendar *calendar;
UIButton *hideCalendarButton;


int daySelected=0;
int monthSelected=0;
int yearSelected=0;

int perSeatPrice;
int seatsAvailable;


int numberOfPosts;

NSMutableArray *places;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@" view did load from..give ride page");
    // Do any additional setup after loading the view.
    
    
    dateSelected = FALSE;

    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"bgrnd2"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    
    [self setAllTimeViews];
    
    [self selectAnytime];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    _selectDate.userInteractionEnabled = YES;
    [_selectDate addGestureRecognizer:singleTap];
    
    
    // get locations from server
    [self getListOfPlaces];
    
    // do parse bring city list before this
    [self fromToPicker];
    
    // this is running before everything gets retreived...mainly for updating the picker .....city list of cities
//    [self runPlaceList];
    
    
    self.priceStepper.delegate = self;

    self.priceStepper.value = -1.0f;
    self.priceStepper.minimumValue = 0.0f;
    self.priceStepper.maximumValue = 500.0f;
    self.priceStepper.stepValue = 1.0f;
    self.priceStepper.autoRepeatInterval = 0.1f;
    
    
    
    // Set some different defaults for the standard stepper
    self.seatsStepper.value = 1.0f;
    self.seatsStepper.autoRepeat = NO;
    
    [self getNumberOfPosts];
    

}

-(void) getNumberOfPosts{

    PFQuery *query = [PFQuery queryWithClassName:@"User"]; //1
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [standardUserDefaults stringForKey:@"currentUser"];
    
    [query whereKey:@"userID" equalTo:userID];//2
    
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        

        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects);
            
            for (PFObject *user in objects) {
            
                NSNumber *previousPostCount = [user objectForKey:@"TotalPosts"];
                NSLog(@" \n\n posts made earlier are..... %@",previousPostCount);

                numberOfPosts = [previousPostCount intValue];
                NSLog(@" int value of posts made %d",numberOfPosts);
            }
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Network Error"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }];



}


// This is the optional delegate callback method
- (void)stepperValueDidChange:(RPVerticalStepper *)stepper
{
    self.priceLabel.text = [NSString stringWithFormat:@"%.f $ /per seat", stepper.value];
    
    perSeatPrice = stepper.value;
}


- (IBAction)stepperDidChange:(RPVerticalStepper *)stepper
{
    self.seatsLabel.text = [NSString stringWithFormat:@"%.f seats", stepper.value];
    
    seatsAvailable = stepper.value;
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
                    
                    [places sortUsingSelector:@selector(caseInsensitiveCompare:)];

                   
                    
                }
                
                
                
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
    
   
    
    ////////
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    fromPlace.inputAccessoryView = toolbar;
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    toPlace.inputAccessoryView = toolbar;
    
  //////////
    
    

    [fromPlace setItemList:places];
    [toPlace setItemList:places];

}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}


-(void)dismissPicker {
    //[fromPlace resignFirstResponder];
    
    [self.superclass endEditing:YES];
}


-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    
//    [self dismissPicker];
    [self selectDate];
    
}

-(void) setAllTimeViews{

    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMorning)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [_morningText addGestureRecognizer:tapGestureRecognizer2];
    _morningText.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAfternoon)];
    tapGestureRecognizer3.numberOfTapsRequired = 1;
    [_afternoonText addGestureRecognizer:tapGestureRecognizer3];
    _afternoonText.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEvening)];
    tapGestureRecognizer4.numberOfTapsRequired = 1;
    [_eveningText addGestureRecognizer:tapGestureRecognizer4];
    _eveningText.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAnytime)];
    tapGestureRecognizer5.numberOfTapsRequired = 1;
    [_AnytimeText addGestureRecognizer:tapGestureRecognizer5];
    _AnytimeText.userInteractionEnabled = YES;

}

-(void) selectMorning{
    
    timeOption =1;
    
    [self clearAllTimeImages];
    
    UIImage *image = [UIImage imageNamed: @"morningSelected2"];
    [_morningText setImage:image];
}

-(void) selectAfternoon{
    
    timeOption =2;
    
    [self clearAllTimeImages];

    UIImage *image = [UIImage imageNamed: @"afternoonSelected"];
    [_afternoonText setImage:image];
}
-(void) selectEvening{
    
    timeOption =3;
    
    [self clearAllTimeImages];
    
    UIImage *image = [UIImage imageNamed: @"evening"];
    [_eveningText setImage:image];

}
-(void) selectAnytime{
    
    timeOption =4;
    
    [self clearAllTimeImages];
    
    UIImage *image = [UIImage imageNamed: @"anytime"];
    [_AnytimeText setImage:image];

}

-(void) clearAllTimeImages{


    UIImage *morning = [UIImage imageNamed: @"morningNotSelected"];
    UIImage *afternoon = [UIImage imageNamed: @"afternoonNotSelected"];
    UIImage *evening = [UIImage imageNamed: @"EveningNotSelected"];
    UIImage *anytime = [UIImage imageNamed: @"AnytimeTimeNotSelected"];



    [_morningText setImage:morning];
    [_afternoonText setImage:afternoon];
    [_eveningText setImage:evening];
    [_AnytimeText setImage:anytime];



    
}



// Prints out the selected date
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSLog(@"%02i,%02i/%02/%i",day,month,year);
    
    
    daySelected = day;
    monthSelected=month;
    yearSelected = year;
    
    
    NSString *MyDate = [NSString stringWithFormat:@"%d-%d-%d", month, day, year];
  //  NSLog(@"date in string %@",MyDate);
    
    DateToUpload = MyDate;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:MyDate];
    
    
    NSLog(@"NSDate value %@", dateFromString);
    
    dateSelected = TRUE;


    int monthNumber = month;   //November
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    NSString *monthName = [[df monthSymbols] objectAtIndex:(monthNumber-1)];
    NSLog(@"Month: %@", monthName);
    

    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM-dd-yyyy"];
    [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
    NSString *currentTimeAgain = [dateFormatter3 stringFromDate:[NSDate date]];
   // NSLog(@"currentTimeAgain %@",currentTimeAgain);
    
    NSDate *currentTimeDateNSDate = [[NSDate alloc] init];
    currentTimeDateNSDate = [dateFormatter dateFromString:currentTimeAgain];
    NSLog(@"Today's NSDate format %@",currentTimeDateNSDate);
    
    
    DateToday = currentTimeDateNSDate;
    SelectedDate = dateFromString;
    
    if ([SelectedDate compare:DateToday] == NSOrderedDescending) {
        NSLog(@"selected date is later after current date");
    } else if ([SelectedDate compare:DateToday] == NSOrderedAscending) {
        NSLog(@"selected date is earlier than current date");
    } else {
        NSLog(@"dates are the same");
    }
    
    
    

    
    // day name
    NSDateFormatter* day2 = [[NSDateFormatter alloc] init];
    [day2 setDateFormat: @"EEEE"];
    NSLog(@"Day Name: %@", [day2 stringFromDate:dateFromString]);
    
    _dayName.text = [day2 stringFromDate:dateFromString];
    _dayNumber.text = [NSString stringWithFormat:@"%d", day];
    _month.text = monthName;
    _year.text =[NSString stringWithFormat:@"%d", year];
    
    
//    calendar.hidden = YES;
    
  
}




// Prints out the month and year displaying on the calendar
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    NSLog(@"also displays the first time");
    NSLog(@"%02/%i",month,year);
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

- (IBAction)backButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)selectDate {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    calendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 40, screenBounds.size.width, screenBounds.size.height-100)];
    calendar.delegate = self;
    
    
    
    
    
    
    [self.view addSubview:calendar];
    
    
    
    UIImage *redButtonImage = [UIImage imageNamed:@"enterIcon"];

    
    hideCalendarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hideCalendarButton addTarget:self
               action:@selector(hideCalendar)
     forControlEvents:UIControlEventTouchUpInside];
    [hideCalendarButton setTitle:nil forState:UIControlStateNormal];
    hideCalendarButton.frame = CGRectMake(110.0, 440, 100, 100.0);
    [hideCalendarButton setBackgroundImage:redButtonImage forState:UIControlStateNormal];
    [self.view addSubview:hideCalendarButton];
    
    
    
    
   
    
    
}

-(void) hideCalendar{
    
    if (dateSelected == FALSE) {
        NSLog(@"nothing seletced");
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please select a date"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        
        if ([SelectedDate compare:DateToday] == NSOrderedDescending) {
            NSLog(@"selected date is later after current date");
            calendar.hidden = YES;
            hideCalendarButton.hidden = YES;
        } else if ([SelectedDate compare:DateToday] == NSOrderedAscending) {
            NSLog(@"selected date is earlier than current date");
            NSLog(@"select date after today");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Select dates after today"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        } else {
            NSLog(@"dates are the same");
            calendar.hidden = YES;
            hideCalendarButton.hidden = YES;
        }
    
       
        
    }

   

}
- (IBAction)post:(id)sender {
    
    NSLog(@"post button pressed");
    
    if (fromPlace.text.length == 0 || toPlace.text.length == 0) {
        NSLog(@" from / to can't be empty");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Select From/To"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    else{
        
        if ([fromPlace.text isEqual:toPlace.text]) {
            NSLog(@"origin destination can't be same");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"From/To can't be same"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }else{
        
            if (_dayNumber.text.length == 0) {
                NSLog(@"date not selected");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Date not selected"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }else{
            
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                NSString *userID = [standardUserDefaults stringForKey:@"currentUser"];

                PFObject *trip = [PFObject objectWithClassName:@"Trips"];//1
                
                [trip setObject:userID forKey:@"user"];
                [trip setObject:DateToUpload forKey:@"Date"];
                
                if (timeOption == 1) {
                    [trip setObject:@"Morning" forKey:@"time"];
                }
                if (timeOption == 2) {
                    [trip setObject:@"Afternoon" forKey:@"time"];
                }
                if (timeOption == 3) {
                    [trip setObject:@"Evening" forKey:@"time"];
                }
                if (timeOption == 4) {
                    [trip setObject:@"Anytime" forKey:@"time"];
                }
                
                
                [trip setObject:[NSNumber numberWithInt:perSeatPrice] forKey:@"pricePerSeat"];
                [trip setObject:[NSNumber numberWithInt:seatsAvailable] forKey:@"totalSeats"];
                
                
                [trip setObject:fromPlace.text forKey:@"From"];
                [trip setObject:toPlace.text forKey:@"To"];
                
                
                
                /////////   backup record
                
                PFObject *tripBackup = [PFObject objectWithClassName:@"TripRecordBackup"];//1
                
                [tripBackup setObject:userID forKey:@"user"];
                [tripBackup setObject:DateToUpload forKey:@"Date"];
                
                if (timeOption == 1) {
                    [tripBackup setObject:@"Morning" forKey:@"time"];
                }
                if (timeOption == 2) {
                    [tripBackup setObject:@"Afternoon" forKey:@"time"];
                }
                if (timeOption == 3) {
                    [tripBackup setObject:@"Evening" forKey:@"time"];
                }
                if (timeOption == 4) {
                    [tripBackup setObject:@"Anytime" forKey:@"time"];
                }
                
                
                [tripBackup setObject:[NSNumber numberWithInt:perSeatPrice] forKey:@"pricePerSeat"];
                [tripBackup setObject:[NSNumber numberWithInt:seatsAvailable] forKey:@"totalSeats"];
                
                
                [tripBackup setObject:fromPlace.text forKey:@"From"];
                [tripBackup setObject:toPlace.text forKey:@"To"];
                
                
                /////////
                
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Posting";
                [hud show:YES];
                
                
                
                [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    [hud hide:YES];
                    
                    if (succeeded){
                        NSLog(@"Posted");
                        
                        
                        //
                        //
                        // now save in backup
                        
                        [tripBackup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            [hud hide:YES];
                            
                            if (succeeded){
                                NSLog(@"Backup posted ");
                                
                                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                                NSString *userID = [standardUserDefaults stringForKey:@"currentUser"];
                                
                                PFQuery *query3 = [PFQuery queryWithClassName:@"User"];
                                [query3 whereKey:@"userID" equalTo:userID];
                                
                                
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeIndeterminate;
                                hud.labelText = @"Posting";
                                [hud show:YES];
                                
                                
                                [query3 getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                                    [hud hide:YES];
                                    
                                    
                                    if (!error) {
                                        // Found UserStats
                                        [userStats setObject:[NSNumber numberWithInt:(numberOfPosts+1)] forKey:@"TotalPosts"];
                                        
                                        
                                        // Save
                                        [userStats saveInBackground];
                                        
                                        
                                        
                                    } else {
                                        // Did not find any UserStats for the current user
                                        NSLog(@"Error: %@", error);
                                        
                                        
                                        
                                    }
                                }];

                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
            
                                
                            }
                            else{
                                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                NSLog(@"Error: %@", errorString);
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:@"Try again"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                
                            }
                            
                        }];

                        
                        
                        
                        //
                        //
                        //
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Posted"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        
                        NSString * storyboardName = @"Main";
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
                        [self presentViewController:vc animated:YES completion:nil];
                        
                    }
                    else{
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"Error: %@", errorString);
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Try again"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    
                }];

            
            }
            
        }
    
    
    }
    
    
}
@end
