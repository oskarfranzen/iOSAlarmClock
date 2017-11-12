//
//  AlarmsTableViewController.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-11-20.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *autoTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveAlarmButton;
@property (weak, nonatomic) IBOutlet UITableView *addAlarmTable;
@property (nonatomic) NSArray *alarmSettings;
@property (weak, nonatomic) IBOutlet UILabel *currentTrackLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmDatePicker;




@end
