//
//  AlarmDetailViewController.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2016-01-03.
//  Copyright (c) 2016 Oskar Franzén. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "AlarmHandler.h"
#import "EventFetcher.h"

@interface AlarmDetailViewController ()

@end

@implementation AlarmDetailViewController
NSArray *remindersAndEvents;
NSString * const reTextFormat = @"HH:MM";
NSDateFormatter *reFormat;

/*! När vyn laddas utförs följande:
    * De klasser som behövs initialiseras
    * Användaren promptas att godkänns tillgång till platstjänster
    * Applikationen startar tjänsten för att hitta användarens position
    * De delegarer som ska användas fastställs
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reminderEventFetch = [[EventFetcher alloc] init];
    self.weatherFetch = [[ClockAPIHandler alloc] init];
    self.weatherFetch.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.weatherFetch.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.weatherFetch.locationManager requestWhenInUseAuthorization];
    }
    [self.weatherFetch prepareLocationManager];
    
    self.weatherFetch.delegate = self;
    self.reminderEventFetch.delegate = self;
    reFormat = [[NSDateFormatter alloc] init];
    reFormat.dateFormat = reTextFormat;

}

/*!
 Visar innehållet i eventsAndReminders i vyns tabell. 
 Hanterar formatering utifrån objectTyp
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reCell" forIndexPath:indexPath];
    
    if ([remindersAndEvents[indexPath.item] isKindOfClass:[EKEvent class]]) {
        EKEvent *forCell = remindersAndEvents[indexPath.item];
        cell.textLabel.text = forCell.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Start: %@ End %@ on location: %@", [reFormat stringFromDate:forCell.startDate],
                                                                                    [reFormat stringFromDate:forCell.endDate], forCell.location];
    } else if ([remindersAndEvents[indexPath.item] isKindOfClass:[EKReminder class]]) {
        EKReminder *forCell = remindersAndEvents[indexPath.item];
        cell.textLabel.text = [NSString stringWithFormat:@"You need to: %@", forCell.title];
        
    } else {
        EKCalendarItem *forCell = remindersAndEvents[indexPath.item];
        cell.textLabel.text = forCell.title;
    }
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return remindersAndEvents.count;
}

/*! Vyn anropas för att uppdatera sin information
 Klasser för modellen anropas */
-(void)updateWithWakeInformation {
    [self.reminderEventFetch eventsForToday];
   [self.weatherFetch weatherForToday];
}

/*! Vyn tar emot hämtade events och visar upp dem i tabellen */
-(void)retrivedTodaysEvents:(NSArray *)events {
    remindersAndEvents = [[NSMutableArray alloc] initWithArray:events];

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.reminderEventTable reloadData];
    });
    
}
/*! Vyn tar emot väderinformation och uppdaterar informationen */
-(void)weatherInfoReturned:(NSString *)temperature andWind:(NSString *)wind {
    self.weatherLabel.text = [NSString stringWithFormat:@"Temperature outside is: %@°\nwith wind speed %@m/s", temperature, wind];
    
}


@end
