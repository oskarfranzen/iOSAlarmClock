//
//  EventFetcher.h
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-25.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@protocol wakeUpDetailsProtocol <NSObject>

-(void)retrivedTodaysEvents:(NSArray *)events;
-(void)weatherInfoReturned:(NSString *)temperature andWind:(NSString *)wind;

@end


@interface EventFetcher : NSObject


@property (nonatomic) NSArray *eventsForAutoTime;
@property (weak, nonatomic) id<wakeUpDetailsProtocol> delegate;


-(NSDate *)autoTimeRequest;
-(void)eventsForToday;

+(EKEventStore *)getEvents;

@end


