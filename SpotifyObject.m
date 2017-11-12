//
//  SpotifyObject.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-21.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "SpotifyObject.h"
#import "SPTSessionHandler.h"

@implementation SpotifyObject

-(id)init {
    if (self = [super init]) {
    self.listToPlay = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)playSignal {
    if (self.signalPlayer == nil) {
        NSLog(@"Skapar ny session");
        self.signalPlayer= [[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID];
    
    [self.signalPlayer loginWithSession:[SPTSessionHandler getSpotifySession] callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in got error: %@", error);
            return;
        }
        
        self.signalPlayer.playbackDelegate = self;
        
       
    }];
        [self.signalPlayer playURIs:self.listToPlay fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
        }];

    } else
        [self.signalPlayer setIsPlaying:YES callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                NSLog(@"Startar som vanligt");
            }
        }];
    }


-(void)stopSignal {
    [self.signalPlayer stop:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        }
        NSLog(@"Stopping spotify Signal");
    }];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.signalPlayer = nil;
    });


    
}
-(void)snoozeSignal {
    NSLog(@"Snoozing alarm");
    [self.signalPlayer skipNext:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
    }];
    [self.signalPlayer setIsPlaying:NO callback:^(NSError *error) {}];
   
}


-(void)translateList{
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    for (SPTPartialTrack *pt in self.listToPlay) {
        [toReturn addObject:pt.uri];
    }
    self.listToPlay = toReturn;
}

-(void)sortListForWake {
    [self translateList];
    if (self.listToPlay.count <= 1) {
        return;
    }
    APIHandler *apiToUse = [[APIHandler alloc] init];
    apiToUse.delegate = self;
    [apiToUse echoNestRequest:self.listToPlay];
    
}

//Något fullösning, skulle egentligen vara bra att ha ett objekt som också håller koll.
-(void)sortRequestReturned:(NSMutableArray *)retVar {
    [self bubbleSort:retVar];

}

//Kod tagen och modifierad från: http://www.knowstack.com/sorting-algorithms-in-objective-c/

-(void)bubbleSort:(NSMutableArray *)unsortedDataArray
{
    long count = unsortedDataArray.count;
    int i;
    bool swapped = TRUE;
    while (swapped){
        swapped = FALSE;
        for (i=1; i<count;i++)
        {
            if ([[unsortedDataArray objectAtIndex:(i-1)] doubleValue] > [[unsortedDataArray objectAtIndex:i] doubleValue])
            {
                [unsortedDataArray exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                [self.listToPlay exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                swapped = TRUE;
            }

        }
    }
}



@end
