//
//  Alarm.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-08.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spotify/Spotify.h"
@class Alarm;
@protocol alarmTriggeredProtocol <NSObject>

-(void)alarmRingUIUpdate;
-(void)alarmRingCancelUpdate;

@end

@interface Alarm : NSObject

@property (weak, nonatomic) NSDate *fireDate;
@property (weak, nonatomic) NSString *alarmName;
@property (weak, nonatomic) NSTimer *snoozeTime;

/*Vad vi behöver

 - Tidpunkt - NSDate
 - Alarmljud - MPMediaplayer/Spotifyplayer
 - Namn - NSString
 - Snoozefunktionalitet NSTimer, rekursivt anrop
 - Påminnelser ?
 - Schemalagda aktiviteter ?
 - Väder ?
*/
@end
