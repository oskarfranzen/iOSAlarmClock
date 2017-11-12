//
//  APIhandler.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-11.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "APIHandler.h"
#import "Spotify/Spotify.h"
#import "SPTSessionHandler.h"
#import "AFNetworking.h"


@interface APIHandler ()
@property (readwrite, strong, nonatomic) NSArray *tempArray;
@end


@implementation APIHandler

const NSString *echoKey = @"QFK2JA8GQRPHMNBUW";

-(void)playlistRequest {
    
    [SPTPlaylistList playlistsForUserWithSession:[SPTSessionHandler getSpotifySession] callback:^(NSError *error, id object) {
        SPTPlaylistList *playlist = (SPTPlaylistList *)object;
        self.tempArray = [playlist items] ;
       
        
    }];
}

-(void)songRequest {
    [SPTYourMusic savedTracksForUserWithAccessToken:[SPTSessionHandler getSpotifySession].accessToken callback:^(NSError *error, id object) {
        if (error != NULL) {
            NSLog(@"%@", error);
            return;
        }

        SPTListPage *tempList = (SPTListPage *)object;
        self.tempArray = [tempList items];
    }];
    
}

-(void)echoNestRequest:(NSArray *)listToSort {
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    AFJSONResponseSerializer *objectSerializer = [AFJSONResponseSerializer serializer];

    
    for (NSURL *item in listToSort) {
        NSString *temp = [item absoluteString];
        NSString *fullPath= [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/song/profile?api_key=%@&track_id=%@&bucket=audio_summary&format=json", echoKey, temp];
        NSURL *toRequest = [[NSURL alloc] initWithString:fullPath];
        NSURLRequest *toOperate = [[NSURLRequest alloc] initWithURL:toRequest];
        AFHTTPRequestOperation *operationToAdd = [[AFHTTPRequestOperation alloc] initWithRequest:toOperate];
        [operationsArray addObject:operationToAdd];
        
        
    }
    if (operationsArray.count == 0) {
        return;
    }
    [operationsArray makeObjectsPerformSelector:@selector(setResponseSerializer:) withObject:objectSerializer];

    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:operationsArray progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSMutableArray *toReturn = [[NSMutableArray alloc] init];
        NSLog(@"All operations in batch complete");
        for (id entry in operations) {
            AFHTTPRequestOperation *temp = (AFHTTPRequestOperation *)entry;
            if ([temp.responseObject isKindOfClass:[NSDictionary class]]) {
                double energyForSong = [self decodeResponse:temp.responseObject];
                [toReturn addObject:[NSNumber numberWithDouble:energyForSong]];
            }
        }
        
        [self.delegate sortRequestReturned:toReturn];
        
    }];
    
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
    
}

-(double)decodeResponse:(NSDictionary *)response {
    NSArray *resultArray = [[response objectForKey:@"response"] objectForKey:@"songs"];
    NSDictionary *responseDic = [resultArray.lastObject objectForKey:@"audio_summary"];
    return [[responseDic objectForKey:@"energy"] doubleValue];
    
}

@end


