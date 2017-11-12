//
//  SPTSessionHandler.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-07.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spotify/Spotify.h"
#import "SpotifyObject.h"
#import "APIHandler.h"
#import "AlarmHandler.h"

@interface SPTSessionHandler : NSObject

@property (weak, nonatomic) id<APIRequestProtocol> delegate;
@property (strong, nonatomic) APIHandler *apiInSession;
@property (strong, nonatomic) SpotifyObject *spotifyToHandle;


-(void)sendRequest:(NSInteger)whichOne;
-(void)listChosen:(NSInteger)index;

+(void)createSPTSession;
+(SPTSession *)getSpotifySession;
+(void)setSpotifySession:(SPTSession *)fooSession;

@end
