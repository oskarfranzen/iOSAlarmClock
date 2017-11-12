//
//  AppDelegate.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-11-19.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "AppDelegate.h"
#import "ClockViewController.h"
#import "SPTSessionHandler.h"
#import "AlarmHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*!
 När applikationen startar utförs följande:
 -Information för Spotify's autentisiering sätts
 -Användaren frågas huruvida denne godkänner att applikationen kommer åt de tjänster den behöver:
    * Påminnelser
    * Kalenderevents
    * Platstjänster
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SPTAuth defaultInstance] setClientID:@"[[[[[[REDACTED]]]]]]]"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"spotifyalarmclock://callback"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope, SPTAuthUserLibraryReadScope]];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    [[EventFetcher getEvents] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
    }];
    [[EventFetcher getEvents] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        
    }];

    return YES;
}

/*!
 Anropas för att genomföra autentisieringen mot Spotify
 */

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }
            [SPTSessionHandler setSpotifySession:session];

        }];
        return YES;
    }
    
    return NO;
}
/*!
 När applikationen tar emot en notifikation anropas de metoder som hanterar alarmet
 */

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[AlarmHandler sharedAlarmHandler] alarmTriggered];

}


@end
