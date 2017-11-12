//
//  SPTSessionHandler.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-07.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "SPTSessionHandler.h"

@implementation SPTSessionHandler

static SPTSession *userSession;
NSArray *toUI;



+(void)createSPTSession {
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:loginURL afterDelay:0.2];    
}

-(void)sendRequest:(NSInteger)whichOne {
    if (whichOne == 1) {
        [self.apiInSession playlistRequest];
    } else {
        [self.apiInSession songRequest];
    }
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        toUI = self.apiInSession.tempArray;
        [self.delegate returnRequest:toUI];
    });
        

}

-(void)listChosen:(NSInteger)index {
    
    self.spotifyToHandle = [[SpotifyObject alloc] init];
    
    //if ([[[toUI[0] class] description] isEqualToString:@"SPTPartialPlaylist" ]) {
        if ([toUI[0] isMemberOfClass:[SPTPartialPlaylist class]]) {
        SPTPartialPlaylist *partTemp = (SPTPartialPlaylist *)toUI[(int)index];
        self.spotifyToHandle.nameOfObject = partTemp.name;
        
        [SPTPlaylistSnapshot playlistWithURI:partTemp.uri
                                 accessToken:[SPTSessionHandler getSpotifySession].accessToken
                                    callback:^(NSError *error, SPTPlaylistSnapshot *object) {
                                        [self.spotifyToHandle.listToPlay addObjectsFromArray:[object.firstTrackPage tracksForPlayback]];
                                
                                        /*if (object.firstTrackPage.hasNextPage) {
                                            [object.firstTrackPage requestNextPageWithAccessToken:[SPTSessionHandler getSpotifySession].accessToken
                                                                                         callback:^(NSError *error, id object) {
                                                                                             if (error != NULL) {
                                                                                                 return;
                                                                                             }
                                                                                             SPTPlaylistSnapshot *toAdd = (SPTPlaylistSnapshot *)object;

                                                                                             [self.spotifyToHandle.listToPlay addObjectsFromArray:                                                                                            toAdd.tracksForPlayback];
                                                                                         }];

                                        }*/
                                                                            }];
    } else if ([[[toUI[0] class] description] isEqualToString:@"SPTSavedTrack"]) {
        SPTSavedTrack *tempTrack = (SPTSavedTrack *)toUI[(int)index];
        self.spotifyToHandle.nameOfObject = tempTrack.name;
        [self.spotifyToHandle.listToPlay addObject:tempTrack];
                            
    }
}


+(SPTSession *)getSpotifySession {
    return userSession;
}
+(void)setSpotifySession:(SPTSession *)fooSession {
    userSession = fooSession;
}



@end

