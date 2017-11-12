//
//  ClockAPIHandler.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2016-01-03.
//  Copyright (c) 2016 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "EventFetcher.h"
#import "AFNetworking.h"


@interface ClockAPIHandler : NSObject

@property (weak, nonatomic) id<wakeUpDetailsProtocol> delegate;
@property (nonatomic) AFHTTPRequestOperation *getWeatherInfo;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) float currentLongitude;
@property (nonatomic) float currentLatitude;

-(void)weatherForToday;
-(void)prepareLocationManager;

@end
