//
//  AlarmHandler.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-08.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "AlarmHandler.h"
#import "SpotifyObject.h"
#import "EventFetcher.h"
#import "ClockAPIHandler.h"

@implementation AlarmHandler
@synthesize thisAlarm;

+(id)sharedAlarmHandler {
    static AlarmHandler *sharedAlarmHander = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAlarmHander = [[AlarmHandler alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedAlarmHander;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


-(void)scheduleAlarmTime:(NSDate *)ringTime {
    self.thisAlarm = [[Alarm alloc] init];
    
   /* if([self date:ringTime is:YES otherDate:[NSDate date]]) {
        ringTime = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:ringTime];

    }*/
    
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    
    alarm.fireDate = ringTime;
    alarm.alertBody = @"Alarm ringing";
    alarm.soundName = UILocalNotificationDefaultSoundName;
    
    NSLog(@"%@", alarm.fireDate);
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
    thisAlarm.fireDate = alarm.fireDate;
    
}

-(void)snoozeAlarm {
    NSDate *ringTime = [NSDate dateWithTimeInterval:(2) sinceDate:[NSDate date]];
    UILocalNotification *snooze = [[UILocalNotification alloc] init];
    snooze.fireDate = ringTime;
    [[UIApplication sharedApplication] scheduleLocalNotification:snooze];
    
}

//Metoden är grundad i följande lösning: http://stackoverflow.com/questions/8746016/how-do-i-determine-whether-an-nsdate-including-time-has-passed

- (BOOL)date:(NSDate*)date is:(BOOL)before otherDate:(NSDate*)otherDate ;
{
    if(before && ([date compare:otherDate] == NSOrderedAscending))
        return YES;
    if (!before && ([date compare:otherDate] == NSOrderedDescending))
        return YES;

    return NO;
}

-(void)alarmTriggered {
    [self.alarmSignal playSignal];
    [self.delegate alarmRingUIUpdate];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 ) {
        [self.alarmSignal snoozeSignal];
        [self snoozeAlarm];
    } else {
        [self.alarmSignal stopSignal];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self alarmIsCanceled];
        });
        
       
    }

}
-(void)alarmIsCanceled {
    self.alarmSignal = nil;
    self.alarmIsSet = false;
    [self.delegate alarmRingCancelUpdate];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

-(void)sortList {
    if (![[[self.alarmSignal class] description] isEqualToString:@"SpotifyObject"]) {
        return;
    }
    SpotifyObject *temp = (SpotifyObject *)self.alarmSignal;
    [temp sortListForWake];
    
    
    
}



@end
