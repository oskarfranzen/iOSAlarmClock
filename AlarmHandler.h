//
//  AlarmHandler.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-08.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@class AlarmHandler;

@protocol alarmSignalProtocol <NSObject>

-(void)playSignal;
-(void)stopSignal;
-(void)snoozeSignal;

@end

@interface AlarmHandler : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) Alarm *thisAlarm;
@property (nonatomic) id<alarmSignalProtocol> alarmSignal;
@property (weak, nonatomic) id<alarmTriggeredProtocol> delegate;
@property (nonatomic) BOOL alarmIsSet;

+ (id)sharedAlarmHandler;
-(void)scheduleAlarmTime:(NSDate *)ringTime;
-(void)alarmTriggered;
-(void)alarmIsCanceled;
-(void)sortList;

@end
