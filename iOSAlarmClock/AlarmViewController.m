//
//  AlarmsTableViewController.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-11-20.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "AlarmViewController.h"
#import "SPTSessionHandler.h"
#import "SpotifySignalViewController.h"
#import "AlarmHandler.h"
#import "EventFetcher.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

EventFetcher *autoTimeFetch;
UIAlertView *showDialog;


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.saveAlarmButton.enabled = false;
    NSLog(@"AlarmView did load");
    self.alarmSettings = @[@"Spotify", @"iTunes"];
    
    self.downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.navigationController.navigationBar addGestureRecognizer:self.downSwipeRecognizer];
    

    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.alarmSettings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.alarmSettings[indexPath.item];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"spotifySignal" sender:self];
            if ([SPTSessionHandler getSpotifySession] == nil) {
                [SPTSessionHandler createSPTSession];
            }
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"iTunesSignal" sender:self];
    }
    [self.addAlarmTable deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation
//Fixa en delegate som hanterar signalval
-(IBAction)unwindToAlarm:(UIStoryboardSegue *)sender {
    self.saveAlarmButton.enabled = true;
    SpotifySignalViewController *tempSource = (SpotifySignalViewController *)sender.sourceViewController;
    self.currentTrackLabel.text = tempSource.chosenSignal;
    
    AlarmHandler *alarm = [AlarmHandler sharedAlarmHandler];
    if (tempSource.spotifyRequest.spotifyToHandle != NULL) {
        alarm.alarmSignal = tempSource.spotifyRequest.spotifyToHandle;
        
    }
}

- (IBAction)downSwipeHanler:(UISwipeGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"returnToClock" sender:self];
}
- (IBAction)saveAlarmPressed:(id)sender {

    AlarmHandler *alarm = [AlarmHandler sharedAlarmHandler];
    [alarm scheduleAlarmTime:self.alarmDatePicker.date];
    alarm.alarmIsSet = true;
    [alarm sortList];
    
    [self performSegueWithIdentifier:@"returnToClock" sender:self];
}
- (IBAction)autoTimePressed:(id)sender {
    //Just nu flyttas datepickern fram en dygn vid autoTime, no esta bueno.
    autoTimeFetch = [[EventFetcher alloc] init];
    NSDate *eventDate= [autoTimeFetch autoTimeRequest];
    
    if (eventDate == NULL) { return;}
    self.alarmDatePicker.date = eventDate;
    showDialog = [[UIAlertView alloc] initWithTitle:@"First event tomorrow is:" message: @"huehue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //[showDialog show];
    //[NSString stringWithFormat:(@"%@", datePickerEvent.title)];

    
}



@end
