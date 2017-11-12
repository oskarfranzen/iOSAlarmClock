//
//  ClockViewController.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-11-19.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmHandler.h"

@interface ClockViewController : UIViewController <alarmTriggeredProtocol>
/*! Visar vad klockan är just nu */
@property (weak, nonatomic) IBOutlet UILabel *CurrTimeLabel;
/*! Visar information om nuvarande alarm */
@property (weak, nonatomic) IBOutlet UILabel *currAlarmLabel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *UpSwipeRecognizer;

@end
