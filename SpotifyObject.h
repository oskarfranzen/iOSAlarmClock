//
//  SpotifyObject.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-21.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spotify/Spotify.h"
#import "AlarmHandler.h"
#import "APIHandler.h"



@interface SpotifyObject : NSObject <APIRequestProtocol, alarmSignalProtocol, SPTAudioStreamingPlaybackDelegate>

@property (weak, nonatomic) NSString *nameOfObject;
@property (nonatomic) NSMutableArray *listToPlay;
@property (nonatomic) SPTAudioStreamingController *signalPlayer;

-(void)sortListForWake;
@end
