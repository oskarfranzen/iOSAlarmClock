//
//  AlarmDetailViewController.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2016-01-03.
//  Copyright (c) 2016 Oskar Franzén. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventFetcher.h"
#import "ClockAPIHandler.h"

/*! Denna klass hanterar visning av all information som ska visas i "ClockViewController"'s container när alarmet ringer. */
@interface AlarmDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, wakeUpDetailsProtocol>


@property (weak, nonatomic) IBOutlet UITableView *reminderEventTable;

/*! Hanterar läsning av de event som ska visas när alarmet ringer */
@property (strong, nonatomic) EventFetcher *reminderEventFetch;

/*! Hanterar läsning från SMHIs API när alarmet ringer */
@property (strong, nonatomic) ClockAPIHandler *weatherFetch;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

-(void)updateWithWakeInformation;

@end
