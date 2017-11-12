//
//  ClockViewController.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-11-19.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "ClockViewController.h"
#import "AlarmViewController.h"
#import "Spotify/Spotify.h"
#import "AlarmDetailViewController.h"




@interface ClockViewController ()

@end

@implementation ClockViewController

/*! Används av klassen för att kontrollera status på alarmet
 */
AlarmHandler *toCheck;

/*! Formatering för labels som visar tidpunkter i vyn */
NSString * const timeTextFormat = @"HH:mm:ss";
NSDateFormatter *dateFormatter;

/*! Visas när alarmet ringer. Användarens input hanteras av AlarmHandler */
UIAlertView *alarmRang;
AlarmDetailViewController *child;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loading Clock View");
    
    child = (AlarmDetailViewController *)self.childViewControllers[0];
    child.view.hidden = YES;
    
    toCheck = [AlarmHandler sharedAlarmHandler];
    toCheck.delegate = self;
    
    alarmRang = [[UIAlertView alloc] initWithTitle:@"Good morning!" message:@"Time to wake up" delegate:[AlarmHandler sharedAlarmHandler] cancelButtonTitle:@"Snooze" otherButtonTitles:@"Ok", nil];
        
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = timeTextFormat;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeLabeltoCurr) userInfo:nil repeats:YES];
    
    self.UpSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.UpSwipeRecognizer];
    
}
/*! 
 När vyn visas uppdateras gränssnittet med aktuell information.
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self setTimeLabeltoCurr];
    self.navigationController.navigationBar.hidden = YES;
    if (toCheck.alarmIsSet == true) {
        self.currAlarmLabel.text = [NSString stringWithFormat:@"Alarm set at \n %@", [dateFormatter stringFromDate:toCheck.thisAlarm.fireDate]];
    } else {
        self.currAlarmLabel.text = @"No Alarm is Set";
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    self.navigationController.navigationBar.hidden = NO;
}

/*!
 Delegat för att uppdatera UIt när alarmet ringer (även vid snooze).
 Visar upp innehållet i child och
 alarmRang */
-(void)alarmRingUIUpdate {
    self.currAlarmLabel.text = @"GOOD MORNING!";
    [alarmRang show];
    if (child.view.hidden == YES) {
        child.view.hidden = NO;
                [child updateWithWakeInformation];
        
    }
}
/*! Anropas av alarmHandler när användaren trycker på OK i alarmRang */
-(void)alarmRingCancelUpdate {
    self.currAlarmLabel.text = @"No Alarm is Set";
    
}

/*! Sätter currTimeLabel till nuvarande klockaslag */
-(void)setTimeLabeltoCurr {
    self.CurrTimeLabel.text =[dateFormatter stringFromDate:[NSDate date]];
}

/*! Hanterar gest för att utföra segue till AlarmViewController */
- (IBAction)handleSwipeUp:(UISwipeGestureRecognizer *)sender {
    [toCheck alarmIsCanceled];
    [self.childViewControllers[0] view].hidden = YES;
    [self performSegueWithIdentifier:@"viewAlarm" sender:self];

    
}

@end
