//
//  EventFetcher.m
//  iOSAlarmClock
//
//  Created by Oskar Franzén on 2015-12-25.
//  Copyright (c) 2015 Oskar Franzén. All rights reserved.
//

#import "EventFetcher.h"

@implementation EventFetcher
static EKEventStore *events;


-(instancetype)init {
    if (self = [super init]) {
        [EventFetcher getEvents];
    }
    return self;
}

-(void)eventsForToday {

    NSDate *eventStart = [NSDate date];
    NSDate *eventEnd = [[self getTomorrowDates] objectAtIndex:0];
    
    
    NSLog(@"Start for events: %@ end for events: %@", eventStart, eventEnd);
    
    NSPredicate *todaysEventFetch = [events predicateForEventsWithStartDate:eventStart endDate:eventEnd calendars:nil];
    NSPredicate *todaysRemindersFetch = [events predicateForIncompleteRemindersWithDueDateStarting:eventStart ending:eventEnd calendars:nil];
    
    NSMutableArray __block *today = [[NSMutableArray alloc] initWithArray:[events eventsMatchingPredicate:todaysEventFetch]];
    [events fetchRemindersMatchingPredicate:todaysRemindersFetch completion:^(NSArray *reminders) {

        [today addObjectsFromArray:reminders];
        [self.delegate retrivedTodaysEvents:today];
    }];
};


-(NSDate *)autoTimeRequest {
        // Create the predicate from the event store's instance method
    NSArray *startEndTomorrow = [self getTomorrowDates];
    NSPredicate *predicate = [events predicateForEventsWithStartDate:startEndTomorrow[0]
                                                             endDate:startEndTomorrow[1]
                                                          calendars:nil];

    // Fetch all events that match the predicate
    self.eventsForAutoTime = [events eventsMatchingPredicate:predicate];
    
        EKEvent *eventToReturn = (EKEvent *)self.eventsForAutoTime[0];
    
        return eventToReturn.startDate;;
}

-(NSDate *)dateWithOutTime:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:datDate];

    comps.hour = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

-(NSArray *)getTomorrowDates {
    NSMutableArray *tomorrowDates = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *beginTomorrowComponents = [[NSDateComponents alloc] init];
    beginTomorrowComponents.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:beginTomorrowComponents
                                                 toDate:[NSDate date]
                                                options:0];
    tomorrow = [self dateWithOutTime:tomorrow];
    [tomorrowDates addObject:tomorrow];
    
    NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = 2;
    NSDate *endOfTomorrow = [calendar dateByAddingComponents:tomorrowComponents
                                                      toDate:[NSDate date]
                                                     options:0];
    
    endOfTomorrow = [self dateWithOutTime:endOfTomorrow];
    [tomorrowDates addObject:endOfTomorrow];
    return tomorrowDates;
}

+(EKEventStore *)getEvents {
    if (events != NULL) {
        return events;
    } else {
        events = [[EKEventStore alloc] init];
        return events;
    }

    
}

@end
