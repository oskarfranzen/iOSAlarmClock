//
//  ClockAPIHandler.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2016-01-03.
//  Copyright (c) 2016 Oskar Franzén. All rights reserved.
//

#import "ClockAPIHandler.h"

@implementation ClockAPIHandler

-(void)weatherForToday {
    
    self.currentLatitude = self.locationManager.location.coordinate.latitude;;
    self.currentLongitude = self.locationManager.location.coordinate.longitude;


    //Iom att jag jobbar med SMHIs API så behöver man sätta sin location till Linköping/annan plats i norden för att callsen ska fungera.
    NSLog(@"%f, %f", self.currentLatitude, self.currentLongitude);
    NSString *requestString = [NSString stringWithFormat:@"http://opendata-download-metfcst.smhi.se/api/category/pmp1.5g/version/1/geopoint/lat/%f/lon/%f/data.json", self.currentLatitude, self.currentLongitude];
    
    NSURL *toRequest = [NSURL URLWithString:requestString];
    NSURLRequest *toOperate  = [[NSURLRequest alloc] initWithURL:toRequest];
    self.getWeatherInfo = [[AFHTTPRequestOperation alloc] initWithRequest:toOperate];

    self.getWeatherInfo.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.getWeatherInfo setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *thisOperaton, id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSArray *time = [responseDic objectForKey:@"timeseries"];
        NSString *temperature = [[time objectAtIndex:9] objectForKey:@"t"];
        NSString *windSpeed = [[time objectAtIndex:9] objectForKey:@"ws"];

        //TODO: FIXA EN LIIIITTE BÄTTRE SAK HÄR :P
        [self.delegate weatherInfoReturned:temperature andWind:windSpeed];
        
    } failure:^(AFHTTPRequestOperation *thisOperation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self.getWeatherInfo start];
    
    
}

-(void)prepareLocationManager {
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    
}

@end
